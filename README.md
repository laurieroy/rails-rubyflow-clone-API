# RubyFlow clone API 

This is a codealong to see how to properly make a TDD API using Rails, RSpec and FactoryBot. However, some of the course was a bit dated (2018), and error handling and serializers jump versions. 

The beginning of the course was updated to use the jsonapi-serializer and jsonapi_errors_handler. I updated the JSON errors in the auth section, and used feature tests. Routing tests are included to quickly check the routes without all of the controller test bloat. 

I am including branch octokit to see how I coded the errors w/out the gem, but reverting to previous code. 

This was built as a [code along](https://www.udemy.com/course/ruby-on-rails-api-the-complete-guide) with Sebastian Wilgosz, making an API similar to RubyFlow.

GEMS Used
- rspec-rails
- factory_bot_rails
- jsonapi-serializer
- octokit - GitHub authorization
- pagy - pagination

These gems were made by the course author:
- jsonapi_errors_handler
- jsom-pagination, a wrapper for pagy

Ruby 2.7.2
Rails 6.1.3.1
RSpec 3.10