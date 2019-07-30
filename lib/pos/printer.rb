require 'open3'

module POS
  class Printer
    attr_reader :name

    def initialize(name)
      @name = name
      @commands = '\e@' # This is ESC/POS initialize command.
    end

    def commands
      @commands.gsub(/'/, "'\"'\"'")
    end

    def print
      send_to_printer
    end

    # ESC/POS commands

    def align_center
      @commands << '\ea\1'
    end

    def align_left
      @commands << '\ea\0'
    end

    def align_right
      @commands << '\ea\2'
    end

    def big_font
      @commands << '\eM\0'
    end

    def cut
      @commands << '\em'
    end

    def double_size
      @commands << '\x1d!\x11'
    end

    def line_feed
      @commands << '\n'
    end

    def normal_size
      @commands << '\x1d!\0'
    end

    def open_drawer
      @commands << '\x1bp\x00\x19\xff\x1bp\x01\x19\xff'
    end

    def print_logo
      @commands << '\x1cp\1\0'
    end

    def small_font
      @commands << '\eM\1'
    end

    def text(str)
      @commands << str
    end

    private

    def send_to_printer
      Open3.capture3('lp', '-d', @name, '-o', 'raw', stdin_data: commands)
    end
  end
end
