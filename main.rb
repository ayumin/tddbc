# coding: utf-8
$:.unshift File.dirname(__FILE__)
require "stringio"
require "circulation_status"
require "book"
require "database"

if __FILE__ == $PROGRAM_NAME
  abort "1.9 only" unless RUBY_VERSION >= "1.9"
  d = Database.new
  puts d.list
  b1 = Book.new
  b1.id = "001"
  b1.title="刀語 第一話 絶刀・鉋"
  b1.author="西尾 維新"
  b1.isbn="9784062836111"
  b1.status=CirculationStatus::BACKORDERED
  b2 = Book.new
  b2.id = "002"
  b2.title="刀語 第二話 斬刀・鈍"
  b2.author="西尾 維新"
  b2.isbn="9784062836043"
  b3 = Book.new
  b3.id = "003"
  b3.title="刀語 第三話 千刀・ツルギ"
  b3.author="西尾 維新"
  b3.isbn="9784062836197"
  b3.status=CirculationStatus::LENDING
  [b1,b2,b3].each{ |b| d.add(b) }
  puts d.list
  p d.find("002")
end
