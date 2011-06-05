# -*- coding: utf-8 -*-
$:.unshift File.dirname(__FILE__)
require 'spec_helper'
require 'main'

MAIN_TEST_BIN_PATH = "main_test.bin"
describe Main do
  describe "book_to_database" do
    before do
      Main.book_to_database(MAIN_TEST_BIN_PATH)
      @database = Database.new(MAIN_TEST_BIN_PATH)
    end
    it "3つのBookがDatabaseに格納されること" do
      @database.find("001").should_not be_nil
      @database.find("002").should_not be_nil
      @database.find("003").should_not be_nil
    end

    it "未登録のBookがDatabaseに格納されていないこと" do
      @database.find("004").should be_nil
    end

    after do 
      FileUtils.rm(MAIN_TEST_BIN_PATH)
    end
  end
end

