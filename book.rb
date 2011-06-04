require 'circulation_status'

class Book
  attr_accessor :id, :title, :author, :isbn, :status

  def initialize( hash = {:id => "0", :title => "", :author => "", :isbn => "", :status => CirculationStatus::STOCKED
} )
    # 書籍ID
    @id = hash[:id]
    # タイトル
    @title = hash[:title]
    # 著者
    @author = hash[:author]
    # ISBN code
    @isbn = hash[:isbn]
    # 状態コード?
    @status = hash.key?(:status) ? hash[:status] : CirculationStatus::STOCKED
  end

  def eql?(other)
    return true if self.equal?(other)
    return false if self.class != other.class
    ( self.id == other.id and
      self.title == other.title and
      self.author == other.author and
      self.isbn == other.isbn and
      self.status == other.status )
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

