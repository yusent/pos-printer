require 'open3'

module POS
  class Printer
    def initialize(name)
      @name = name
      @commands = ''
    end

    def commands
      @commands.gsub(/'/, "'\"'\"'")
    end

    def print
      send_to_printer
    end

    private

    def send_to_printer
      Open3.capture3('lp', '-d', @name, '-o', 'raw', stdin_data: commands)
    end
  end
end
