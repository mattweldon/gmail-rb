require 'rspec'
require 'rspec/core'
require 'fileutils'
require 'dotenv'
# require 'vcr'
# require 'webmock'

require_relative '../lib/gmail-rb'

Dotenv.load(File.expand_path("../.env",  __FILE__))

# VCR.configure do |c|
#   c.cassette_library_dir = 'fixtures/vcr_cassettes'
#   c.hook_into :webmock # or :fakeweb
# end