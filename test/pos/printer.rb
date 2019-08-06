require 'test/unit'
require_relative '../../lib/pos/printer'

class POS::Printer
  attr_reader :name, :commands, :lp_options
end

class TestPrinter < Test::Unit::TestCase
  def setup
    @printer_name = 'test'
    @lp_options = ['-h', 'somehost:port']
    @printer = POS::Printer.new(@printer_name, @lp_options)
  end

  def assert_commands_equal(str)
    assert_equal(str, @printer.commands)
  end

  def test_initialize
    assert_equal(@printer.name, @printer_name)
    assert_commands_equal("\e@")
    assert_equal(@printer.lp_options,
      ['-d', @printer_name, '-o', 'raw', *@lp_options])
  end

  def test_align_center
    @printer.align_center
    assert_commands_equal("\e@\ea\1")
  end

  def test_align_left
    @printer.align_left
    assert_commands_equal("\e@\ea\0")
  end

  def test_align_right
    @printer.align_right
    assert_commands_equal("\e@\ea\2")
  end

  def test_big_font
    @printer.big_font
    assert_commands_equal("\e@\eM\0")
  end

  def test_cut
    @printer.cut
    assert_commands_equal("\e@\em")
  end

  def test_double_size
    @printer.double_size
    assert_commands_equal("\e@\x1d!\x11")
  end

  def test_line_feed
    @printer.line_feed
    assert_commands_equal("\e@\n")
    @printer.line_feed 3
    assert_commands_equal("\e@\n\n\n\n")
  end

  def test_normal_size
    @printer.normal_size
    assert_commands_equal("\e@\x1d!\0")
  end

  def test_open_drawer
    @printer.open_drawer
    assert_commands_equal("\e@\x1bp\x00\x19\xff\x1bp\x01\x19\xff")
  end

  def test_print_logo
    @printer.print_logo
    assert_commands_equal("\e@\x1cp\1\0")
  end

  def test_qr_code
    @printer.qr_code 'test'
    assert_commands_equal("\e@\x1B\x61\x01"\
      "\x1D\x28\x6B\x03\x00\x31\x43\x04"\
      "\x1D\x28\x6B\x03\x00\x31\x45\x33"\
      "\x1D\x28\x6B\x07\x00\x31\x50\x30"\
      'test'\
      "\x1D\x28\x6B\x03\x00\x31\x51\x30")
  end

  def test_small_font
    @printer.small_font
    assert_commands_equal("\e@\eM\1")
  end

  def test_text
    @printer.text 'some text'
    assert_commands_equal("\e@some text")
  end

  def test_text_line
    @printer.text_line 'some text'
    assert_commands_equal("\e@some text\n")
  end
end
