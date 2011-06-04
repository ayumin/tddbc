# -*- coding: utf-8 -*-
$:.unshift File.dirname(__FILE__)
require 'spec_helper'
require 'database'
require 'book'
TEM_DATASTORE = 'tmp.bin'
describe "Database をブロックなしで使用する場合" do
  before do
    @database = Database.new TEM_DATASTORE
  end
  describe "インスタンス化されたとき" do
    subject {@database}
    describe "keyMap" do
      it do
        subject.keyMap.class.should == Hash
      end
    end
    describe "offset" do
      it do
        subject.offset.should == 0
      end
    end
    describe "datastore" do
      it do
        subject.datastore.class.should == File
      end
    end
  end

  describe "bookをaddした場合" do
    subject {@database}
    describe "findで取得した book と同一である" do
      it do
        book = Book.new
        book.id = "10"
        subject.add(book)
        found_book = subject.find(book.id)
        found_book.eql?(book).should be_true
      end
    end
  end

  describe "close を呼び出した場合" do
    subject {@database}
    it do
      subject.close
      expect{subject.add(Book.new)}.should raise_error
    end
  end

  after do
    FileUtils.rm(TEM_DATASTORE)
  end
end
describe "Database をブロックを使用して処理をする場合" do
  it do
    storebook = Book.new({:id=>"200", :title=>"tddbc2.0", :author=>"volpe_hd28v", :isbn=>"1234567890111"})
    Database.new(TEM_DATASTORE) {|d| d.add(storebook); }
    database = Database.new TEM_DATASTORE
    findbook = database.find("200");
    storebook.eql?(findbook).should be_true
  end
  after do
    FileUtils.rm(TEM_DATASTORE)
  end
end
