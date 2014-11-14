Given /^the following custom queries$/ do |table|
  table.hashes.map{|item| item.dup}.each do |item|
    VirtuosoPlugin::CustomQuery.create!(item.merge(:environment => Environment.default))
  end
end
