$: << File.dirname(__FILE__)
$: << File.dirname(__FILE__) + '/../vendor/rufus-tokyo/lib'

require 'metry/rack/tracking'
require 'metry/memory'
require 'metry/tokyo'
require 'metry/experiment'