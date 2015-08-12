require "option_parser"

module Hashify
    module Command
        def self.run()
            options = {
                :function => "md5",
                :recurse => false
            }

            OptionParser.new do |opts|
                opts.banner = "Usage: hashify DIR [options]"

                opts.on("-f FUNCTION", "--function FUNCTION", "The hashing function to use") do |f|
                    options[:function] = f
                end

                opts.on("-r", "--recurse", "") do |r|
                    options[:recurse] = true
                end

                opts.on("-h", "--help", "Show this menu") do
                    puts opts

                    exit
                end

                opts.unknown_args do |args, after_dash|
                    options[:directory] = fetch_required_parameter(opts, args, "DIR")
                end
            end.parse!

            run(options)
        end

        private def self.fetch_required_parameter(opts, args, name)
            if args.empty?
                puts "#{name} is missing"
                puts opts
                exit 1
            end

            args.shift
        end

        private def self.run(options)
            puts options
        end
    end
end
