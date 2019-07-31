[![Build Status](https://travis-ci.org/yusent/pos-printer.svg?branch=master)](https://travis-ci.org/yusent/pos-printer)

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

More Information
----------------

* [Rubygems](https://rubygems.org/gems/pos-printer)
* [Issues](https://github.com/yusent/pos-printer/issues)
