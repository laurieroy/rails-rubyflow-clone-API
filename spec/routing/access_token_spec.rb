require "rails_helper"

RSpec.describe "/access_tokens routes" do
	it "routes to access_tokens#create" do
		expect(post "/login").to route_to("access_tokens#create")
	end

		# it "routes to access_tokens destroy action" do
		# 	expect(delete "/logout").to route_to("access_tokens#destroy")
		# end
end