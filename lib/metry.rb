$: << File.dirname(__FILE__)

require 'metry/storage'
require 'metry/rack/tracking'
require 'metry/experiment'
require 'metry/psycho'

module Metry
  VERSION = '1.2.0'
  
  def self.init(dbname)
    @storage = Storage.new(dbname)
  end
  
  def self.current
    @storage
  end
end