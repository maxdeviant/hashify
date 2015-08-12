require "option_parser"
require "crypto/md5"

module Hashify
    module Command
        def self.run()
            # TODO: Use something less type-crazy
            options = {
                :function => "md5",
                :recurse => false,
                :files => [] of String
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
                    options[:files] = args
                end
            end.parse!

            run(options)
        end

        private def self.run(options)
            files = options[:files] as Array(String)

            files = files.select { |e| File.file?(e) }

            files.each do |file|
                directory = File.dirname(file)
                extension = File.extname(file)
                hash = hash(file)

                File.rename(file, File.join(directory, "#{hash}#{extension}"))
            end
        end

        private def self.hash(filename)
            contents = File.read(filename)

            Crypto::MD5.hex_digest(contents)
        end
    end
end
