#!/usr/bin/env ruby
# frozen_string_literal: true
require 'date'
require 'optparse'
require './migration_util.rb'


def date_parser file, date
	begin
  		Date.strptime(date, MigrationUtil::Timestamp_format)
	rescue => e
		puts "The migration filename: '#{ file }' has an invalid name, ensure the date is following the format: '#{ MigrationUtil::Timestamp_format }'"
  		puts "Exception Class: #{ e.class.name }"
  		puts "Exception Message: #{ e.message }"
  		puts "Exception Backtrace: #{ e.backtrace }"
  		exit 1
	end
end


Options = Struct.new(:dir, :timestamp)

class Parser
  def self.parse(options)
    args = Options.new(options)

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: validate_migration_version.sh [options]"

      opts.on("-dDIR", "--db-migration-dir=DIR", "Migrations directory") do |n|
        args.dir = n
      end

      opts.on("-t", "--[no-]timestamp [FLAG]", TrueClass, "Uses timestamp as version") do |v|
        args.timestamp = v.nil? ? false : v
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    return args
  end
end

arguments = ARGV

if(ARGV.length == 0)
  arguments = ["--help"]
end

options = Parser.parse arguments

puts "Database migrations directory: '#{options.dir}'"
puts "Uses timestamp as version?: '#{options.timestamp}'"

files = Dir["#{options.dir}/*.sql"]


if(options.timestamp)
  files.each { |file| 

	filename = File.basename(file, ".sql") 
	migration_timestamp = filename.split("__")[0][1..-1]

    date_parser(file, migration_timestamp)
  }
else
  puts "Skipping timestamp format validation"
end