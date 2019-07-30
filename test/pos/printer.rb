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
end
