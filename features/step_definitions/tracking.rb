Given /^an empty tracking database$/ do
  METRY.clear
end

Then /^there should be (\d+) tracking events?$/ do |event_count|
  assert_equal(event_count.to_i, METRY.event_count)
end

When /^there should be a tracking event "(\d+)":$/ do |id, table|
  event = METRY[id]
  assert event, "Unable to lookup event #{id} in #{METRY.inspect}."
  table.hashes.each do |hash|
    expected = hash["value"]
    case expected
    when "_exists_"
      assert event[hash["key"]], "Key #{hash["key"]} does not exist."
    else
      assert_equal expected, event[hash["key"]], "Key #{hash["key"]} does not match in #{METRY.inspect}."
    end
  end
end

Then /^there should be a visitor "([^\"]*)":$/ do |id, table|
  visitor = METRY.visitor(id)
  assert visitor, "Unable to lookup visitor #{id} in #{METRY.inspect}."
  table.hashes.each do |hash|
    expected = hash["value"]
    case expected
    when "_exists_"
      assert visitor[hash["key"]], "Key #{hash["key"]} does not exist."
    else
      assert_equal expected, visitor[hash["key"]], "Key #{hash["key"]} does not match in #{METRY.inspect}."
    end
  end
end
