module Phare
  class Check
    attr_reader :status

    def initialize(directory)
      @directory = directory
      @directory << '/' unless @directory.end_with?('/')
    end

    def run
      ruby = Checks::RubyRubocop.new
      ruby.run

      jshint = Checks::JavaScriptJSHint.new(@directory)
      jshint.run

      jscs = Checks::JavaScriptJSCS.new(@directory)
      jscs.run

      @status = [ruby.status, jshint.status, jscs.status].find { |status| status > 0 } || 0
    end
  end
end
