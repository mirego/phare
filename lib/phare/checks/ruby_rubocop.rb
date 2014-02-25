module Phare
  module Checks
    class RubyRubocop
      attr_reader :status

      def initialize
        @command = 'bundle exec rubocop'

        puts '----------------------------------------'
        puts 'Running Rubocop to check for Ruby style…'
        puts '----------------------------------------'
      end

      def run
        system(@command)
        @status = $CHILD_STATUS.exitstatus

        unless @status == 0
          puts "Something went wrong. Program exited with #{@status}"
        end
      end
    end
  end
end
