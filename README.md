[![Gem Version](https://badge.fury.io/rb/pos-printer.svg)](https://rubygems.org/gems/pos-printer)

# pos-printer
Ruby library for printing using ESC/POS (thermal) printers using CUPS.

Install
--------

Add the following line to Gemfile:

```ruby
gem 'pos-printer'
```

and run `bundle install` from your shell.

To install the gem manually from your shell, run:

```shell
gem install pos-printer
```

Usage
----------------

```ruby
require 'pos-printer'

POS::Printer.print('my-printer-name-on-cups') do |p|
  p.align_center
  p.print_logo
  p.big_font
  p.text 'MY HEADER'
  p.align_left
  p.small_font
  p.text 'some body'
end
```

You may also specify extra options to pass to `lp`:

```ruby
require 'pos-printer'

POS::Printer.print('my-printer-name-on-cups', lp_options: ['-h', 'somehost:port']) do |p|
  # Your printing code
end
```

More Information
----------------

* [Rubygems](https://rubygems.org/gems/pos-printer)
* [Issues](https://github.com/yusent/pos-printer/issues)
