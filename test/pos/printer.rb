require 'test/unit'
require_relative '../../lib/pos/printer'

class TestPrinter < Test::Unit::TestCase
  def setup
    @printer_name = 'test'
    @printer = POS::Printer.new(@printer_name)
  end

  def test_initialize
    assert_equal(@printer.name, @printer_name)
    assert_equal(@printer.commands, '\e@')
  end

  def test_align_center
    @printer.align_center
    assert_equal(@printer.commands, '\e@\ea\1')
  end

  def test_align_left
    @printer.align_left
    assert_equal(@printer.commands, '\e@\ea\0')
  end

  def test_align_right
    @printer.align_right
    assert_equal(@printer.commands, '\e@\ea\2')
  end

  def test_big_font
    @printer.big_font
    assert_equal(@printer.commands, '\e@\eM\0')
  end

  def test_cut
    @printer.cut
    assert_equal(@printer.commands, '\e@\em')
  end

  def test_double_size
    @printer.double_size
    assert_equal(@printer.commands, '\e@\x1d!\x11')
  end

  def test_line_feed
    @printer.line_feed
    assert_equal(@printer.commands, '\e@\n')
  end

  def test_normal_size
    @printer.normal_size
    assert_equal(@printer.commands, '\e@\x1d!\0')
  end

  def test_open_drawer
    @printer.open_drawer
    assert_equal(@printer.commands, '\e@\x1bp\x00\x19\xff\x1bp\x01\x19\xff')
  end

  def test_print_logo
    @printer.print_logo
    assert_equal(@printer.commands, '\e@\x1cp\1\0')
  end

  def test_small_font
    @printer.small_font
    assert_equal(@printer.commands, '\e@\eM\1')
  end

  def test_text(str)
    @printer.text('some text')
    assert_equal(@printer.commands, '\e@some text')
  end
end
