# coding: utf-8

require "stringio"

module CirculationStatus
  # 入荷待ち
  BACKORDERED = :BACKORDERED
  # 在庫有
  STOCKED = :STOCKED
  # 貸出中
  LENDING = :LENDING
  # 抹消
  ERASURED = :ERASURED
end

class Book
  attr_accessor :id, :title, :author, :isbn, :status

  def initialize
    # 書籍ID
    @id = "0"
    # タイトル
    @title = ""
    # 著者
    @author = ""
    # ISBN code
    @isbn = ""
    # 状態コード
    @status = CirculationStatus::STOCKED
  end

  def eql?(other)
    return true if self.equal?(other)
    return false if other.nil?
    return false if self.class != other.class

    if author.nil?
      return false unless other.author.nil?
    else
      return false unless author == other.author
    end

    if id.nil?
      return false unless other.id.nil?
    else
      return false unless id == other.id
    end

    if isbn.nil?
      return false unless other.isbn.nil?
    else
      return false unless isbn == other.isbn
    end

    return false unless status == other.status

    if title.nil?
      return false unless other.title.nil?
    else
      return false unless title == other.title
    end

    true
  end

  def hash
    prime = 31
    result = 1
    result = prime * (result + (author.nil? ? 0 : author.hash))
    result = prime * (result + (id.nil? ? 0 : id.hash))
    result = prime * (result + (isbn.nil? ? 0 : isbn.hash))
    result = prime * (result + (status.nil? ? 0 : status.hash))
    result = prime * (result + (title.nil? ? 0 : title.hash))
    result
  end

  def to_s
    "Book[id=\"#{id}\", title=\"#{title}\", author=\"#{author}\", isbn=\"#{isbn}\", status=:#{status}]"
  end

end

class Database
  DATASTORE_NAME = "book.bin"
  LEN_ID = 8
  LEN_TITLE = 512
  LEN_AUTHOR = 128
  LEN_ISBN = 16
  LEN_STATUS = 16
  OFFSET_ID = 0
  OFFSET_TITLE = OFFSET_ID + LEN_ID
  OFFSET_AUTHOR = OFFSET_TITLE + LEN_TITLE
  OFFSET_ISBN = OFFSET_AUTHOR + LEN_AUTHOR
  OFFSET_STATUS = OFFSET_ISBN + LEN_ISBN
  LENGTH = LEN_ID + LEN_TITLE + LEN_AUTHOR + LEN_ISBN + LEN_STATUS
  EMPTY_STRING = "\x00"*LENGTH 

  attr_accessor :keyMap, :offset, :datastore

  def initialize
    @keyMap = Hash.new
    @offset = 0
    @datastore = File.open(DATASTORE_NAME, "a+b")
    loop{
      @datastore.seek(@offset)
      b = @datastore.read(LEN_ID)
      break unless b
      key = b.unpack("A*").first
      @keyMap[key] = @offset
      @offset += LENGTH
    }
    @offset = 0
  end

  def add(book)
    @keyMap[book.id] = @datastore.pos
    @datastore.write(to_byte(book))
  end

  def find(key)
    return nil unless @keyMap.include?(key)
    @offset = @keyMap[key]
    @datastore.seek(@offset)
    bytes = @datastore.read(LENGTH)
    to_entry(bytes)
  end

  def list
    @keyMap.keys.collect{ |key| find(key) }
  end

  def to_byte(book)
    bytes = "\x00"*LENGTH
    offset = 0

    write = proc{ |str,len|
      bytes[offset, str.bytesize] = str.unpack("a*").first
      offset += len
    }

    write[book.id, LEN_ID]
    write[book.title, LEN_TITLE]
    write[book.author, LEN_AUTHOR]
    write[book.isbn, LEN_ISBN]
    write[book.status.to_s, LEN_STATUS]
    bytes
  end

  def to_entry(bytes)
    reader = StringIO.new(bytes, "r")
    offset = 0

    readString = proc{ |len|
      begin
        data = reader.read(len)
        data.unpack("A*").first.force_encoding("utf-8")
      rescue
        ""
      ensure
        offset += len
      end
    }

    book = Book.new
    book.id = readString[LEN_ID]
    book.title = readString[LEN_TITLE]
    book.author = readString[LEN_AUTHOR]
    book.isbn = readString[LEN_ISBN]
    book.status = CirculationStatus.const_get(readString[LEN_STATUS])
    book
  end

end

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
