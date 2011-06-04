# -*- coding: utf-8 -*-
$:.unshift File.dirname(__FILE__)
require 'spec_helper'
require 'book'

describe Book do
  describe "インスタンス化されたとき" do
    before do
      @book = Book.new
    end
    context "id" do
      subject { @book.id }
      it { should == "0" }
    end
    context "title" do
      subject { @book.title }
      it { should == "" }
    end
    context "autor" do
      subject { @book.author }
      it { should == "" }
    end
    context "isbn" do
      subject { @book.isbn }
      it { should == "" }
    end
    context "status" do
      subject { @book }
      it { should == CirculationStatus::STOCKED }
    end
  end
end

