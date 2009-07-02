class MetryExtension < Radiant::Extension
  version "1.0"
  description "Provides Metry support to Radiant."
  url "http://terralien.com/projects"
  
  def activate
    Page.class_eval do
      include MetryTags
    end
  end
end
