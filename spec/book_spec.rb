# -*- coding: utf-8 -*-
$:.unshift File.dirname(__FILE__)
require 'spec_helper'
require 'book'

describe Book do
  describe "インスタンス化されたとき" do
    before do
      @book = Book.new
    end
    subject {@book}
    describe "id" do
      it do
        subject.id.should == "0"
      end
    end
    describe "title" do
      it do
        subject.title.should == ""
      end
    end
    describe "subject" do
      it do
        subject.author.should == ""
      end
    end
    describe "isbn" do
      it do
        subject.isbn.should == ""
      end
    end
    describe "status" do
      it do
        subject.status.should == CirculationStatus::STOCKED
      end
    end
  end
end

