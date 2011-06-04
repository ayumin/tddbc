# -*- coding: utf-8 -*-
$:.unshift File.dirname(__FILE__)
require 'spec_helper'
require 'database'

describe Database do
  describe "インスタンス化されたとき" do
    before do
      @database = Database.new "book.bin"
    end
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
#    describe "datastore" do
#      it do
#        subject.datastore.class.should == File
#      end
#    end
  end
end
