module Phare
  module Checks
    class RubyRubocop
      attr_reader :status

      def initialize
        @command = 'bundle exec rubocop'
      end

      def run
        if should_run?
          print_banner
          system(@command)
          @status = $CHILD_STATUS.exitstatus

          unless @status == 0
            puts "Something went wrong. Program exited with #{@status}"
          end

          puts ''
        else
          @status = 0
        end
      end

    protected

      def should_run?
        !`which rubocop`.empty?
      end

      def print_banner
        puts '----------------------------------------'
        puts 'Running Rubocop to check for Ruby style…'
        puts '----------------------------------------'
      end
    end
  end
end
