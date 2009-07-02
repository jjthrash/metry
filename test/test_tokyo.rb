require File.dirname(__FILE__) + '/shared'

class TestTokyo < Test::Unit::TestCase
  context "An empty database" do
    setup do
      @tokyo = Metry::Tokyo.new('test')
      @tokyo.clear
    end
    
    should "be empty" do
      assert_equal 0, @tokyo.event_count
    end
  end
end