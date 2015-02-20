# encoding: utf-8
module Phare
  class Check
    class ScssLint < Check
      attr_reader :path

      def initialize(directory, options = {})
        @path = File.expand_path("#{directory}app/assets/stylesheets", __FILE__)
        @extensions = %w(.scss)
        @options = options

        super
      end

      def command
        if @tree.changed?
          "scss-lint #{@tree.changes.join(' ')}"
        else
          "scss-lint #{@path}"
        end
      end

    protected

      def excluded_files
        [] # TODO: Fetch the exclude list from .scss-lint.yml
      end

      def binary_exists?
        !Phare.system_output('which scss-lint').empty?
      end

      def arguments_exists?
        @tree.changed? || Dir.exist?(@path)
      end

      def print_banner
        Phare.banner 'Running SCSS-Lint to check for SCSS style…'
      end
    end
  end
end
