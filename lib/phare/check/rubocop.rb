# encoding: utf-8
module Phare
  class Check
    class Rubocop < Check
      def initialize(directory, options = {})
        @path = directory
        @extensions = %w(.rb)
        @options = options
      end

      def command
        if tree_changed?
          "rubocop #{tree_changes.join(' ')}"
        else
          'rubocop'
        end
      end

    protected

      def binary_exists?
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
