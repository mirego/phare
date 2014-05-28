# encoding: utf-8
module Phare
  class CLI
    attr_reader :suite

    def initialize(env, argv)
      @env = env
      @argv = argv
      @options = parsed_options

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

  protected

    def parsed_options
      options = { directory: Dir.getwd }
      options = parse_options_from_yaml(options)
      options = parse_options_from_arguments(options)

      options[:skip].map!(&:to_sym) if options[:skip]
      options[:only].map!(&:to_sym) if options[:only]

      options
    end

    def parse_options_from_arguments(options)
      OptionParser.new do |opts|
        opts.banner = 'Usage: phare [options]'

        opts.on('--directory', 'The directory in which to run the checks (default is the current directory') do |directory|
          options[:directory] = directory
        end

        opts.on('--skip x,y,z', 'Skip checks') do |checks|
          options[:skip] = checks.split(',')
        end

        opts.on('--only x,y,z', 'Only run the specified checks') do |checks|
          options[:only] = checks.split(',')
        end

        opts.on('--diff', 'Only run checks on modified files') do
          options[:diff] = true
        end

      end.parse! @argv

      options
    end

    def parse_options_from_yaml(options)
      file = File.join(options[:directory], '.phare.yml')

      if File.exist?(file)
        # Load YAML content
        content = YAML.load_file(file)

        # Symbolize keys
        new_options = content.reduce({}) do |memo, (key, value)|
          memo.merge! key.to_sym => value
        end

        # And merge with existing options
        options = options.merge(new_options)
      end

      options
    end
  end
end
