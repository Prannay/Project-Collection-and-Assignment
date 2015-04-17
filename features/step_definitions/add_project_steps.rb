require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

When(/^I click "([^\"]*)"$/) do |link|
	click_link(link)
end

Then(/^I should visit (.+)$/) do |page_name|
	visit path_to(page_name)
end
