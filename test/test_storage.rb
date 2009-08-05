require File.dirname(__FILE__) + '/shared'

class TestTokyo < Test::Unit::TestCase
  context "An empty database" do
    setup do
      @storage = Metry::Storage.new('test')
      @storage.clear
    end
    
    should "be empty" do
      assert_equal 0, @storage.event_count
    end
  end
end