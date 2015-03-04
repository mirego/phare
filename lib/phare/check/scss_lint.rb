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
          "scss-lint #{files_to_check.join(' ')}"
        else
          "scss-lint #{@path}"
        end
      end

    protected

      def excluded_list
        configuration_file['exclude']
      end

      def configuration_file
        @configuration_file ||= File.exist?('.scss-lint.yml') ? YAML::load(File.open('.scss-lint.yml')) : {}
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
