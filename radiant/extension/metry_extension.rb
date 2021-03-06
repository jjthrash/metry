require 'metry'

load 'metry_authenticator.rb'

class MetryExtension < Radiant::Extension
  version "1.0"
  description "Provides Metry support to Radiant."
  url "http://terralien.com/projects"
  
  def activate
    Page.class_eval do
      include MetryTags
      
      def metry_active=(state)
        @metry_active = state
      end
      
      def metry_active?
        @metry_active
      end
      
      def cache_with_metry?
        (cache_without_metry? && !metry_active?)
      end
      alias_method_chain :cache?, :metry
    end

    Metry.init 'radiant-tracking'
    Rails.configuration.middleware.insert_after ActionController::Failsafe, Metry::Rack::Tracking
    Rails.configuration.middleware.use proc{Metry::Psycho}, {
      :path => "/admin/metry",
      :authorize => proc{|env| MetryAuthenticator.new(env).authorized?},
      :on_deny => proc {|env| MetryAuthenticator.new(env).redirect},
    }
  end
end
