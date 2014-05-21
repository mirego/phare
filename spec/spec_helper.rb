$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'phare'

RSpec.configure do |config|
  config.before(:each) do
    # Disable all logging
    allow(Phare).to receive(:puts)
  end
end

RSpec::Matchers.define :be_able_to_run do
  match do |actual|
    actual.send(:should_run?) == true
  end
end

RSpec::Matchers.define :exit_with_code do |expected_code|
  actual = nil

  match do |block|
    begin
      block.call
    rescue SystemExit => e
      actual = e.status
    end

    actual && actual == expected_code
  end

  supports_block_expectations do
    true
  end

  failure_message do |block|
    "expected block to call exit(#{expected_code}) but exit" +
      (actual.nil? ? ' not called' : "(#{actual}) was called")
  end

  failure_message_when_negated do |block|
    "expected block not to call exit(#{expected_code})"
  end

  description do
    "expect block to call exit(#{expected_code})"
  end
end
