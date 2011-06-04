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

