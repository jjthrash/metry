Given /^an empty tracking database$/ do
  begin
    File.delete(TRACKING_FILE)
  rescue Errno::ENOENT
  end
end

Then /^there should be (\d+) tracking entr(?:y|ies)$/ do |entries|
  Marshal.load(File.read(TRACKING_FILE)).size == entries.to_i
end

When /^there should be a tracking entry "(\d+)":$/ do |id, table|
  storage = Marshal.load(File.read(TRACKING_FILE))
  entry = storage["entries"][id.to_i]
  assert entry, "Unable to lookup entry #{id} in #{storage.inspect}."
  table.hashes.each do |hash|
    expected = hash["value"]
    case expected
    when "_exists_"
      assert entry[hash["key"]], "Key #{hash["key"]} does not exist."
    else
      assert_equal expected, entry[hash["key"]], "Key #{hash["key"]} does not match in #{storage.inspect}."
    end
  end
end
