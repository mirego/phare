module Phare
  class CheckSuite
    attr_reader :status

    def initialize(directory)
      @directory = directory
      @directory << '/' unless @directory.end_with?('/')
    end

    def run
      @checks = []

      @checks << Check::Rubocop.new
      @checks.last.run

      @checks << Check::ScssLint.new(@directory)
      @checks.last.run

      @checks << Check::JSHint.new(@directory)
      @checks.last.run

      @checks << Check::JSCS.new(@directory)
      @checks.last.run

      @status = @checks.map!(&:status).find { |status| status > 0 } || 0
    end
  end
end
