Then /^I should see the same "([^\"]*)" alternative (\d+) times$/ do |experiment, count|
  events = Metry.current.last_events(count.to_i)
  assert_equal count.to_i, events.size
  seen = events.collect{|e| e["experiment.#{experiment}"]}.uniq
  assert_equal 1, seen.size, "More than one seen in #{events.collect{|e| [e[:pk], e["visitor"], e["time"], e["experiment.#{experiment}"]]}.inspect}"
end

Then /^at least (\d+) should see alternative "([^\"]*)" of experiment "([^\"]*)"$/ do |count, alternative, experiment|
  events = Metry.current.all_events
  matching_count = events.select{|e| e["experiment.#{experiment}"] == alternative}.size
  assert matching_count > count.to_i
end
