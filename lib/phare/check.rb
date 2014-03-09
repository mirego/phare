module Phare
  class Check
    attr_reader :status

    def initialize(directory)
      @directory = directory
      @directory << '/' unless @directory.end_with?('/')
    end

    def run
      @checks = []

      @checks << Checks::RubyRubocop.new
      @checks.last.run

      @checks << Checks::ScssLint.new(@directory)
      @checks.last.run

      @checks << Checks::JavaScriptJSHint.new(@directory)
      @checks.last.run

      @checks << Checks::JavaScriptJSCS.new(@directory)
      @checks.last.run

      @status = @checks.map!(&:status).find { |status| status > 0 } || 0
    end
  end
end
