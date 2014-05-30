# encoding: utf-8
module Phare
  class CLI
    attr_reader :suite

    def initialize(env, argv)
      @env = env
      @options = parsed_options(argv)

      @suite = Phare::CheckSuite.new(@options)
    end

    def run
      if @env['SKIP_CODE_CHECK']
        Phare.banner 'Skipping code style checking… Really? Well alright then…'
        exit 0
      else
        if @suite.tap(&:run).status == 0
          Phare.banner 'Everything looks good, keep on committing!'
          exit 0
        else
          Phare.banner 'Something’s wrong with your code style. Please fix it before committing.'
          exit 1
        end
      end
    end

  protected

    def parsed_options(argv)
      options = { directory: Dir.getwd }
      options.merge! parsed_options_from_yaml(File.join(options[:directory], '.phare.yml'))
      options.merge! parsed_options_from_arguments(argv)

      options[:skip].map!(&:to_sym) if options[:skip]
      options[:only].map!(&:to_sym) if options[:only]

      options
    end

    def parsed_options_from_arguments(argv)
      options_to_merge = {}

      OptionParser.new do |opts|
        opts.banner = 'Usage: phare [options]'

        opts.on('--directory', 'The directory in which to run the checks (default is the current directory') do |directory|
          options_to_merge[:directory] = directory
        end

        opts.on('--skip x,y,z', 'Skip checks') do |checks|
          options_to_merge[:skip] = checks.split(',')
        end

        opts.on('--only x,y,z', 'Only run the specified checks') do |checks|
          options_to_merge[:only] = checks.split(',')
        end

        opts.on('--diff', 'Only run checks on modified files') do
          options_to_merge[:diff] = true
        end

      end.parse! argv

      options_to_merge
    end

    def parsed_options_from_yaml(file)
      options_to_merge = {}

      if File.exist?(file)
        # Load YAML content
        content = YAML.load(File.read(file))

        # Symbolize keys
        options_to_merge = content.reduce({}) do |memo, (key, value)|
          memo.merge! key.to_sym => value
        end
      end

      options_to_merge
    end
  end
end
