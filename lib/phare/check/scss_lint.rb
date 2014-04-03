# encoding: utf-8
module Phare
  class Check
    class ScssLint < Check
      attr_reader :path

      def initialize(directory, options = {})
        @path = File.expand_path("#{directory}app/assets/stylesheets", __FILE__)
        @extensions = %w(.css .scss)
        @options = options
      end

      def command
        if tree_changed?
          "scss-lint #{tree_changes.join(' ')}"
        else
          "scss-lint #{@path}"
        end
      end

    protected

      def binary_exists?
        !Phare.system_output('which scss-lint').empty?
      end

      def arguments_exists?
        tree_changed? || Dir.exists?(@path)
      end

      def print_banner
        Phare.puts '------------------------------------------'
        Phare.puts 'Running SCSS-Lint to check for SCSS style…'
        Phare.puts '------------------------------------------'
      end
    end
  end
end
