# encoding: utf-8
module Phare
  class Check
    class Rubocop < Check
      def initialize(directory, options = {})
        @path = directory
        @extensions = %w(.rb)
        @options = options

        super
      end

      def command
        if @tree.changed?
          "rubocop #{@tree.changes.join(' ')}"
        else
          'rubocop'
        end
      end

    protected

      def binary_exists?
        !Phare.system_output('which rubocop').empty?
      end

      def print_banner
        Phare.banner 'Running Rubocop to check for Ruby style…'
      end
    end
  end
end
