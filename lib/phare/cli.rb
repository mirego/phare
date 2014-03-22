module Phare
  class CLI
    def initialize(env)
      if env['SKIP_CODE_CHECK']
        puts '--------------------------------------------------------'
        puts 'Skipping code style checking… Really? Well alright then…'
        puts '--------------------------------------------------------'

        exit 0
      else
        if Phare::CheckSuite.new(Dir.getwd).tap { |c| c.run }.status == 0
          puts '------------------------------------------'
          puts 'Everything looks good, keep on committing!'
          puts '------------------------------------------'

          exit 0
        else
          puts '------------------------------------------------------------------------'
          puts 'Something’s wrong with your code style. Please fix it before committing.'
          puts '------------------------------------------------------------------------'

          exit 1
        end
      end
    end
  end
end
