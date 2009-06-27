Given /^an empty tracking database$/ do
  TRACKING_STORAGE.clear
end

Then /^there should be (\d+) tracking events?$/ do |event_count|
  TRACKING_STORAGE.size == event_count.to_i
end

When /^there should be a tracking event "(\d+)":$/ do |id, table|
  event = TRACKING_STORAGE[id]
  assert event, "Unable to lookup event #{id} in #{TRACKING_STORAGE.inspect}."
  table.hashes.each do |hash|
    expected = hash["value"]
    case expected
    when "_exists_"
      assert event[hash["key"]], "Key #{hash["key"]} does not exist."
    else
      assert_equal expected, event[hash["key"]], "Key #{hash["key"]} does not match in #{TRACKING_STORAGE.inspect}."
    end
  end
end
