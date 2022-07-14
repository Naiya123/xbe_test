# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "database_cleaner-active_record"
require "ezcater_matchers"
require 'sidekiq/testing'
Sidekiq::Testing.inline!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.disable_monkey_patching!
  config.default_formatter = "doc" if config.files_to_run.one?
  config.order = :random
  Kernel.srand config.seed

  DATABASE_NAME = "xbe_test_test"

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.after(:suite) do
    ActiveRecord::Base.connection_pool.disconnect!
  end

  config.before do |example|
    DatabaseCleaner.strategy = example.metadata[:cleaner_strategy] || :transaction
  end

  config.before do
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
