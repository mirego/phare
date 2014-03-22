module Phare
  class CheckSuite
    attr_reader :status

    CHECKS = [Check::Rubocop, Check::ScssLint, Check::JSHint, Check::JSCS]

    def initialize(directory)
      @directory = directory
      @directory << '/' unless @directory.end_with?('/')
    end

    def run
      @checks = CHECKS.map do |check|
        check.new(@directory).tap(&:run).status
      end

      @status = @checks.find { |status| status > 0 } || 0
    end
  end
end
