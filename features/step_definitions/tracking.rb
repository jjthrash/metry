Given /^an empty tracking database$/ do
  Metry.current.clear
end

Then /^there should be (\d+) tracking events?$/ do |event_count|
  assert_equal(event_count.to_i, Metry.current.event_count)
end

When /^there should be a tracking event "(\d+)":$/ do |id, table|
  event = Metry.current[id]
  assert event, "Unable to lookup event #{id}."
  table.hashes.each do |hash|
    expected = hash["value"]
    case expected
    when "_exists_"
      assert event[hash["key"]], "Key #{hash["key"]} does not exist."
    else
      assert_equal expected, event[hash["key"]], "Key #{hash["key"]} does not match."
    end
  end
end

Then /^there should be a visitor "([^\"]*)":$/ do |id, table|
  visitor = Metry.current.visitor(id)
  assert visitor, "Unable to lookup visitor #{id}."
  table.hashes.each do |hash|
    expected = hash["value"]
    case expected
    when "_exists_"
      assert visitor[hash["key"]], "Key #{hash["key"]} does not exist."
    else
      assert_equal expected, visitor[hash["key"]], "Key #{hash["key"]} does not match."
    end
  end
end
