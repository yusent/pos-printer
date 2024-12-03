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
      @commands = "\e@".b # This is ESC/POS initialize command.
      @lp_options = ['-d', name, '-o', 'raw', *lp_options]
    end

    def print
      Open3.capture3('lp', *@lp_options, binmode: true, stdin_data: @commands)
    end

    # ESC/POS commands
    # FMI: http://www.bixolon.com/upload/download/unified%20command%20manual_rev_1_01.pdf

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

    def line_feed(n = 1)
      add_command "\n" * n
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

    def barcode(str, dpi = 162, width = 3)
      add_command "\x1D\x48\x00"
      add_command "\x1B\x61\x01"
      add_command "\x1D\x68#{dpi.chr}"
      add_command "\x1D\x77#{width.chr}"
      add_command "\x1D\x6B\x49#{str.size.chr}"
      add_command str
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

    def select_character_code_table(chr_table)
      add_command "\et#{get_chr_table_code(chr_table)}"
    end

    def small_font
      add_command "\eM\1"
    end

    def text(str)
      add_command str
    end

    def text_line(str)
      add_command str
      line_feed
    end

    private

    def add_command(command)
      @commands << replace_spanish_characters(command)
      return
    end

    def get_chr_table_code(chr_table_sym)
      case chr_table_sym
      when :usa
        0
      when :katakana
        1
      when :multilingual
        2
      when :portuguese
        3
      when :canadian_french
        4
      when :nordic
        5
      when :latin_1
        16
      when :cyrillic_2
        17
      when :latin_2
        18
      when :euro
        19
      when :hebrew_dos_code
        21
      when :arabic
        22
      when :thai_42
        23
      when :greek
        24
      when :turkish
        25
      when :baltic
        26
      when :farsi
        27
      when :cyrillic
        28
      when :greek_2
        29
      when :baltic_2
        30
      when :thai_14
        31
      when :hebrew_new_code
        33
      when :thai_11
        34
      when :thai_18
        35
      when :cyrillic_3
        36
      when :turkish_2
        37
      when :greek_3
        38
      when :thai_16
        39
      when :arabic_2
        40
      when :vietnam
        41
      when :space
        255
      else
        0
      end.chr
    end

    def replace_spanish_characters(str)
      # Codes from: http://www.bixolon.com/upload/download/srp-f310312_code%20pages_english_rev_1_00.pdf
      str
        .b
        .gsub("Á".b, "\xB5".b)
        .gsub("É".b, "\x90".b)
        .gsub("Í".b, "\xD6".b)
        .gsub("Ó".b, "\xE0".b)
        .gsub("Ú".b, "\xE9".b)
        .gsub("Ñ".b, "\xA5".b)
        .gsub("á".b, "\xA0".b)
        .gsub("é".b, "\x82".b)
        .gsub("í".b, "\xA1".b)
        .gsub("ó".b, "\xA2".b)
        .gsub("ú".b, "\xA3".b)
        .gsub("ñ".b, "\xA4".b)
    end
  end
end
