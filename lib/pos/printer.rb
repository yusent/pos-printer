require 'open3'

module POS
  class Printer
    def self.print(printer_name, lp_options: [])
      printer = self.new(printer_name, lp_options)
      yield printer
      printer.print
    end

    def initialize(name, lp_options = [])
      @name = name
      @commands = "\e@" # This is ESC/POS initialize command.
      @lp_options = ['-d', name, '-o', 'raw', *lp_options]
    end

    def print
      Open3.capture3('lp', *@lp_options, stdin_data: @commands)
    end

    # ESC/POS commands

    def align_center
      add_command "\ea\1"
    end

    def align_left
      add_command "\ea\0"
    end

    def align_right
      add_command "\ea\2"
    end

    def big_font
      add_command "\eM\0"
    end

    def cut
      add_command "\em"
    end

    def double_size
      add_command "\x1d!\x11"
    end

    def line_feed
      add_command "\n"
    end

    def normal_size
      add_command "\x1d!\0"
    end

    def open_drawer
      add_command "\x1bp\x00\x19\xff\x1bp\x01\x19\xff"
    end

    def print_logo
      add_command "\x1cp\1\0"
    end

    def qr_code(str)
      qr_size = 4
      s = str.size + 3
      lsb = s % 256
      msb = s / 256

      add_command "\x1B\x61\x01"
      add_command "\x1D\x28\x6B\x03\x00\x31\x43#{qr_size.chr}"
      add_command "\x1D\x28\x6B\x03\x00\x31\x45\x33"
      add_command "\x1D\x28\x6B#{lsb.chr}"
      add_command "#{msb.chr}\x31\x50\x30"
      add_command str
      add_command "\x1D\x28\x6B\x03\x00\x31\x51\x30"
    end

    def small_font
      add_command "\eM\1"
    end

    def text(str)
      add_command str
    end

    private

    def add_command(command)
      @commands << command
      return
    end
  end
end
