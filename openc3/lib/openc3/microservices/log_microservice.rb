# encoding: ascii-8bit

# Copyright 2022 Ball Aerospace & Technologies Corp.
# All Rights Reserved.
#
# This program is free software; you can modify and/or redistribute it
# under the terms of the GNU Affero General Public License
# as published by the Free Software Foundation; version 3 with
# attribution addendums as found in the LICENSE.txt
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# Modified by OpenC3, Inc.
# All changes Copyright 2022, OpenC3, Inc.
# All Rights Reserved
#
# This file may also be used under the terms of a commercial license
# if purchased from OpenC3, Inc.

require 'openc3/microservices/microservice'
require 'openc3/topics/topic'
require 'openc3/logs/buffered_packet_log_writer'
require 'openc3/config/config_parser'

module OpenC3
  class LogMicroservice < Microservice
    def initialize(name)
      super(name)
      @config['options'].each do |option|
        case option[0].upcase
        when 'RAW_OR_DECOM'
          @raw_or_decom = option[1].intern
        when 'CMD_OR_TLM'
          @cmd_or_tlm = option[1].intern
        when 'CYCLE_TIME' # Maximum time between log files
          @cycle_time = option[1].to_i
        when 'CYCLE_SIZE' # Maximum size of a log file
          @cycle_size = option[1].to_i
        when 'BUFFER_DEPTH' # Buffer depth to write in time order
          @buffer_depth = option[1].to_i
        else
          Logger.error("Unknown option passed to microservice #{@name}: #{option}")
        end
      end

      raise "Microservice #{@name} not fully configured" unless @raw_or_decom and @cmd_or_tlm

      # These settings limit the log file to 10 minutes or 50MB of data, whichever comes first
      @cycle_time = 600 unless @cycle_time # 10 minutes
      @cycle_size = 50_000_000 unless @cycle_size # ~50 MB

      @buffer_depth = 10 unless @buffer_depth
    end

    def run
      setup_plws()
      while true
        break if @cancel_thread

        Topic.read_topics(@topics) do |topic, msg_id, msg_hash, redis|
          break if @cancel_thread
          log_data(topic, msg_id, msg_hash, redis)
        end
      end
    end

    def setup_plws
      @plws = {}
      @topics.each do |topic|
        topic_split = topic.gsub(/{|}/, '').split("__") # Remove the redis hashtag curly braces
        scope = topic_split[0]
        target_name = topic_split[2]
        packet_name = topic_split[3]
        type = @raw_or_decom.to_s.downcase
        remote_log_directory = "#{scope}/#{type}_logs/#{@cmd_or_tlm.to_s.downcase}/#{target_name}"
        rt_label = "#{scope}__#{target_name}__ALL__rt__#{type}"
        stored_label = "#{scope}__#{target_name}__ALL__stored__#{type}"
        @plws[target_name] ||= {
          :RT => BufferedPacketLogWriter.new(remote_log_directory, rt_label, true, @cycle_time, @cycle_size, nil, nil, @buffer_depth),
          :STORED => BufferedPacketLogWriter.new(remote_log_directory, stored_label, true, @cycle_time, @cycle_size, nil, nil, @buffer_depth)
        }
      end
    end

    def log_data(topic, msg_id, msg_hash, redis)
      start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      topic_split = topic.gsub(/{|}/, '').split("__") # Remove the redis hashtag curly braces
      target_name = topic_split[2]
      packet_name = topic_split[3]
      rt_or_stored = ConfigParser.handle_true_false(msg_hash["stored"]) ? :STORED : :RT
      packet_type = nil
      data_key = nil
      if @raw_or_decom == :RAW
        packet_type = :RAW_PACKET
        data_key = "buffer"
      else # :DECOM
        packet_type = :JSON_PACKET
        data_key = "json_data"
      end
      @plws[target_name][rt_or_stored].buffered_write(packet_type, @cmd_or_tlm, target_name, packet_name, msg_hash["time"].to_i, rt_or_stored == :STORED, msg_hash[data_key], nil, topic, msg_id)
      @count += 1
      diff = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start # seconds as a float
      metric_labels = { "packet" => packet_name, "target" => target_name, "raw_or_decom" => @raw_or_decom.to_s, "cmd_or_tlm" => @cmd_or_tlm.to_s }
      @metric.add_sample(name: "log_duration_seconds", value: diff, labels: metric_labels)
    rescue => err
      @error = err
      Logger.error("#{@name} error: #{err.formatted}")
    end

    def shutdown
      # Make sure all the existing logs are properly closed down
      threads = []
      @plws.each do |target_name, plw_hash|
        plw_hash.each do |type, plw|
          threads.concat(plw.shutdown)
        end
      end
      # Wait for all the logging threads to move files to buckets
      threads.flatten.compact.each do |thread|
        thread.join
      end
      super()
    end
  end
end

OpenC3::LogMicroservice.run if __FILE__ == $0
