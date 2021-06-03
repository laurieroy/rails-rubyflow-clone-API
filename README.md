# RubyFlow clone API 

This is a codealong to see how to properly make a TDD API using Rails, RSpec and factoryBot. However, some of the course was a bit dated. The beginning of the course was updated to use the jsonapi-serializer and jsonapi_errors_handler. I updated the JSON errors in the auth section, and used feature tests. Routing tests are included to quickly check the routes without all of the controller test bloat. 


This was built as a [code along](https://www.udemy.com/course/ruby-on-rails-api-the-complete-guide) with Sebastian Wilgosz, making an API similar to RubyFlow.

GEMS Used
- rspec-rails
- factory_bot_rails
- jsonapi-serializer
- jsonapi_errors_handler
- jsom-pagination, a wrapper for pagy
- octokit - GitHub authorization
- pagy - pagination


Ruby 2.7.2
Rails 6.1.3.1
RSpec 3.10