# -*- coding: utf-8 -*-
$:.unshift File.dirname(__FILE__)
require 'spec_helper'
require 'database'
require 'book'
TEM_DATASTORE = 'tmp.bin'
describe Database do
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

