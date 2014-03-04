module Phare
  class Check
    attr_reader :status

    def initialize(directory)
      @directory = directory
      @directory << '/' unless @directory.end_with?('/')
    end

    def run
      @checks = []

      @checks << ruby = Checks::RubyRubocop.new
      ruby.run

      @checks << scsslint = Checks::ScssLint.new(@directory)
      scsslint.run

      @checks << jshint = Checks::JavaScriptJSHint.new(@directory)
      jshint.run

      @checks << jscs = Checks::JavaScriptJSCS.new(@directory)
      jscs.run

      @status = @checks.map!(&:status).find { |status| status > 0 } || 0
    end
  end
end
