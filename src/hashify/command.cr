require "option_parser"
require "crypto/md5"

module Hashify
    module Command
        class Options
            property function
            property recurse
            property number
            property files

            def initialize
                @function = "md5"
                @recurse = false
                @number = 0
                @files = [] of String
            end
        end

        def self.run
            options = Options.new

            OptionParser.new do |opts|
                opts.banner = "Usage: hashify DIR [options]"

                opts.on("-f FUNCTION", "--function FUNCTION", "The hashing function to use") do |f|
                    options.function = f
                end

                opts.on("-n PLACES", "--number PLACES") do |n|
                    options.number = n.to_i
                end

                opts.on("-r", "--recurse", "") do |r|
                    options.recurse = true
                end

                opts.on("-h", "--help", "Show this menu") do
                    puts opts

                    exit
                end

                opts.unknown_args do |args, after_dash|
                    options.files = args
                end
            end.parse!

            run(options)
        end

        private def self.run(options)
            files = options.files

            files = files.select { |e| File.file?(e) }

            files.each_with_index do |file, index|
                directory = File.dirname(file)
                extension = File.extname(file)
                hash = hash(file)

                number_prefix = options.number > 0 ? (index + 1).to_s.rjust(options.number, '0') + "_" : ""

                File.rename(file, File.join(directory, "#{number_prefix}#{hash}#{extension}"))
            end
        end

        private def self.hash(filename)
            contents = File.read(filename)

            Crypto::MD5.hex_digest(contents)
        end
    end
end
