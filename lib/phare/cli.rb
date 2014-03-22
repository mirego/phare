module Phare
  class CLI
    attr_reader :suite

    def initialize(env)
      @env = env
      @suite = Phare::CheckSuite.new(Dir.getwd)
    end

    def run
      if @env['SKIP_CODE_CHECK']
        Phare.puts '--------------------------------------------------------'
        Phare.puts 'Skipping code style checking… Really? Well alright then…'
        Phare.puts '--------------------------------------------------------'

        exit 0
      else
        if @suite.tap { |suite| suite.run }.status == 0
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
  end
end
