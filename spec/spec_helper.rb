require 'simplecov'
SimpleCov.start

require 'pry'
require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

require 'mailboxlayer'
