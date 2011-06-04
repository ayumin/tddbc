class Database
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

  def initialize (datastore_name)
    @keyMap = Hash.new
    @offset = 0
    @datastore = File.open(datastore_name, "a+b")
    loop{
      @datastore.seek(@offset)
      b = @datastore.read(LEN_ID)
      break unless b
      key = b.unpack("A*").first
      @keyMap[key] = @offset
      @offset += LENGTH
    }
    @offset = 0

    if block_given?
      yield self
      self.close
    end
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

  def close
    @datastore.close
  end

end


