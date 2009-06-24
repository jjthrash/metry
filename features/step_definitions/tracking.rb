Given /^an empty tracking database$/ do
  File.delete(TRACKING_FILE)
end

Then /^I should have (\d+) tracking entr(?:y|ies)$/ do |entries|
  Marshal.load(File.read(TRACKING_FILE)).size == entries.to_i
end

When /^I read the tracking entry "(\d+)":$/ do |id, table|
  entry = Marshal.load(File.read(TRACKING_FILE))[id.to_i]
  assert entry, "Unable to lookup entry #{id}."
  table.hashes.each do |hash|
    expected = hash["value"]
    case expected
    when "_exists_"
      assert entry[hash["key"]], "Key #{hash["key"]} does not exist."
    else
      assert_equal expected, entry[hash["key"]]
    end
  end
end
