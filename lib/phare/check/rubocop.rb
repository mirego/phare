module Phare
  class Check
    class Rubocop < Check
      def initialize(*args)
        @command = 'rubocop'
      end

      def run
        if should_run?
          print_banner
          Phare.system(@command)
          @status = Phare.last_exit_status

          unless @status == 0
            Phare.puts "Something went wrong. Program exited with #{@status}"
          end

          Phare.puts ''
        else
          @status = 0
        end
      end

    protected

      def should_run?
        !Phare.system_output('which rubocop').empty?
      end

      def print_banner
        Phare.puts '----------------------------------------'
        Phare.puts 'Running Rubocop to check for Ruby style…'
        Phare.puts '----------------------------------------'
      end
    end
  end
end
