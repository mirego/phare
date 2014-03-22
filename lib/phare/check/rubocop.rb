# encoding: utf-8
module Phare
  class Check
    class Rubocop < Check
      def initialize(directory)
        @path = directory
      end

      def command
        'rubocop'
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
