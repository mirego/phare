module Phare
  class CheckSuite
    attr_reader :status

    DEFAULT_CHECKS = {
      rubocop: Check::Rubocop,
      stylelint: Check::Stylelint,
      eslint: Check::Eslint
    }

    def initialize(options = {})
      @options = options

      @directory = options[:directory]
      @directory << '/' unless @directory.end_with?('/')

      @options[:skip] ||= []
      @options[:only] ||= []
    end

    def checks
      checks = DEFAULT_CHECKS.keys

      if @options[:only].any?
        checks &= @options[:only]
      elsif @options[:skip]
        checks - @options[:skip]
      else
        checks
      end
    end

    def run
      @checks = checks.map do |check|
        check = DEFAULT_CHECKS[check]
        check.new(@directory, @options).tap(&:run).status
      end

      @status = @checks.find { |status| status > 0 } || 0
    end
  end
end
