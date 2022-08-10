JSONAPI.configure do |config|
  config.default_paginator = :paged # default is :none
  config.default_page_size = 50 # default is 10
  config.maximum_page_size = 100 # default is 20
end