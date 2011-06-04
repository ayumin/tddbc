# -*- coding: utf-8 -*-
$:.unshift File.dirname(__FILE__)
require 'spec_helper'
require 'book'

describe Book do
  describe "引数なしでインスタンス化されたとき" do
    before do
      @book = Book.new()
    end
    context "id" do
      subject { @book.id }
      it { should == "0" }
    end
    context "title" do
      subject { @book.title }
      it { should == "" }
    end
    context "author" do
      subject { @book.author }
      it { should == "" }
    end
    context "isbn" do
      subject { @book.isbn }
      it { should == "" }
    end
    context "status" do
      subject { @book.status }
      it { should == CirculationStatus::STOCKED }
    end
  end

  describe "引数ありでインスタンス化されたとき" do
    before do
      @book = Book.new({:id    => "10",
                        :title => "hoge",
                        :author => "fuga",
                        :isbn  => "123456789",
                        :status => CirculationStatus::STOCKED,
                        })
    end
    context "id" do
      subject { @book.id }
      it { should == "10" }
    end
    context "title" do
      subject { @book.title }
      it { should == "hoge" }
    end
    context "author" do
      subject { @book.author }
      it { should == "fuga" }
    end
    context "isbn" do
      subject { @book.isbn }
      it { should == "123456789" }
    end
    context "status" do
      subject { @book.status }
      it { should == CirculationStatus::STOCKED }
    end
  end

  describe "bookの属性値が等しければeqlである" do
    before do
      @book1 = Book.new
      @book2 = Book.new
    end
    context "empty book is equal" do
      it {@book1.eql?(@book2).should be_true}
    end
    context "has same value book is equal" do
      it {
        [@book1,  @book2].each{ |b|
          b.id = "010"
          b.title = "tddbc"
          b.author = "ayumin"
          b.isbn = "1234567890123"
          b.status = CirculationStatus::LENDING
        }
        @book1.eql?(@book2).should be_true
      }
    end
    context "has not same value book is not equal" do
      it {
        [@book1,  @book2].each{ |b|
          b.id = "010"
          b.title = "tddbc"
          b.author = "ayumin"
          b.isbn = "1234567890123"
          b.status = CirculationStatus::LENDING
        }
        @book2.title = "tdddc"
        @book1.eql?(@book2).should be_false
      }
    end
  end
end

