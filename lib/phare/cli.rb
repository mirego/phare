# encoding: utf-8
module Phare
  class CLI
    attr_reader :suite

    def initialize(env, argv)
      @env = env
      @argv = argv
      parse_options

      @suite = Phare::CheckSuite.new(@options)
    end

    def run
      if @env['SKIP_CODE_CHECK']
        Phare.puts '--------------------------------------------------------'
        Phare.puts 'Skipping code style checking… Really? Well alright then…'
        Phare.puts '--------------------------------------------------------'

        exit 0
      else
        if @suite.tap(&:run).status == 0
          Phare.puts '------------------------------------------'
          Phare.puts 'Everything looks good, keep on committing!'
          Phare.puts '------------------------------------------'

          exit 0
        else
          Phare.puts '------------------------------------------------------------------------'
          Phare.puts 'Something’s wrong with your code style. Please fix it before committing.'
          Phare.puts '------------------------------------------------------------------------'

          exit 1
        end
      end
    end

    def parse_options
      @options = { directory: Dir.getwd }

      OptionParser.new do |opts|
        opts.banner = 'Usage: phare [options]'

        opts.on('--directory', 'The directory in which to run the checks (default is the current directory') do |directory|
          @options[:directory] = directory
        end

        opts.on('--skip x,y,z', 'Skip checks') do |checks|
          @options[:skip] = checks.split(',').map(&:to_sym)
        end

        opts.on('--only x,y,z', 'Only run the specified checks') do |checks|
          @options[:only] = checks.split(',').map(&:to_sym)
        end

        opts.on('--diff', 'Only run checks on modified files') do
          @options[:diff] = true
        end

      end.parse! @argv
    end
  end
end
