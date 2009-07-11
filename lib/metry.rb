$: << File.dirname(__FILE__)
$: << File.dirname(__FILE__) + '/../vendor/rufus-tokyo/lib'

require 'metry/rack/tracking'
require 'metry/memory'
require 'metry/tokyo'
require 'metry/experiment'

module Metry
  VERSION = '1.1.0'
  
  def self.init(storage)
    @storage = storage
  end
  
  def self.current
    @storage
  end
end