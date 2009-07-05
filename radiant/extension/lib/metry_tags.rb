module MetryTags
  include Radiant::Taggable

  desc %{ All metry-related tags live inside this one. }
  tag "metry" do |tag|
    tag.locals.alternatives = {}
    tag.locals.event = tag.globals.page.request.env["metry.event"]
    tag.expand
  end
  
  desc %{ Wrap your control in this and nest your alternatives. }
  tag "metry:experiment" do |tag|
    control = tag.expand
    options = tag.locals.alternatives.merge("control" => control)
    Metry::Experiment.new(tag.attr["name"], tag.locals.event).choose(options, tag.attr["method"])
  end
  
  desc %{ Alternatives go in here with a name. }
  tag "metry:experiment:alternative" do |tag|
    tag.locals.alternatives[tag.attr["name"]] = tag.expand
    ''
  end

end