module MetryTags
  include Radiant::Taggable
  
  desc %{ All metry-related tags live inside this one. }
  tag "metry" do |tag|
    tag.locals.alternatives = {}
    tag.expand
  end
  
  tag "metry:experiment" do |tag|
    control = tag.expand
    options = tag.locals.alternatives.merge(:control => control)
    visitor = METRY.visitor(tag.globals.page.request.env["metry.visitor"])
    visitor.choose(tag.attr["name"], options)
  end
  
  tag "metry:experiment:alternative" do |tag|
    tag.locals.alternatives
  end
  
end