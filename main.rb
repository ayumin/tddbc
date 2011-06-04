# coding: utf-8
$:.unshift File.dirname(__FILE__)
require "stringio"
require "circulation_status"
require "book"
require "database"
class Main
  class << self
    def book_to_database(path)
      d = Database.new(path)
      puts d.list
      b1 = Book.new({
        :id => "001",
        :title=>"刀語 第一話 絶刀・鉋",
        :author=>"西尾 維新",
        :isbn=>"9784062836111",
        :status=>CirculationStatus::BACKORDERED
      })
      b2 = Book.new({
        :id => "002",
        :title=>"刀語 第二話 斬刀・鈍",
        :author=>"西尾 維新",
        :isbn=>"9784062836043"
      })
      b3 = Book.new({
        :id => "003",
        :title=>"刀語 第三話 千刀・ツルギ",
        :author=>"西尾 維新",
        :isbn=>"9784062836197",
        :status=>CirculationStatus::LENDING
      })
      [b1,b2,b3].each{ |b| d.add(b) }
      puts d.list
      p d.find("002")
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  abort "1.9 only" unless RUBY_VERSION >= "1.9"
  Main.book_to_database("book.bin")
end

