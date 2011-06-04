# -*- coding: utf-8 -*-
$:.unshift File.dirname(__FILE__)
require 'spec_helper'
require 'book'
require 'circulation_status'

describe Book do
  describe "インスタンス化されたとき" do
    before do
      @book = Book.new
    end
    subject {@book}
    it do
      subject.id.should == "0"
    end
    it do
      subject.title.should == ""
    end
    it do
      subject.author.should == ""
    end
    it do
      subject.isbn.should == ""
    end
    it do
      subject.status.should == CirculationStatus::STOCKED
    end
  end
end

