# encoding: utf-8
module Phare
  class Check
    class ScssLint < Check
      # Constants
      DEFAULT_PATH = 'app/assets/stylesheets'.freeze

      # Accessors
      attr_reader :path

      def initialize(directory, options = {})
        @directory = directory
        @extensions = %w(.scss)
        @options = options

        super
      end

      def command
        if @tree.changed?
          "scss-lint #{files_to_check.join(' ')}"
        else
          "scss-lint #{expanded_path}"
        end
      end

    protected

      def expanded_path
        File.expand_path(@directory + path, __FILE__)
      end

      def path
        scss_files = configuration_file['scss_files']

        return DEFAULT_PATH unless scss_files

        if scss_files.respond_to?(:join)
          scss_files.join(' ')
        else
          scss_files
        end
      end

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
        @tree.changed? || Dir.exist?(expanded_path)
      end

      def print_banner
        Phare.banner 'Running SCSS-Lint to check for SCSS style…'
      end
    end
  end
end
