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
          "rubocop #{files_to_check.join(' ')}"
        else
          'rubocop'
        end
      end

    protected

      def excluded_files
        return [] unless configuration_file['AllCops'] && configuration_file['AllCops']['Exclude']

        configuration_file['AllCops']['Exclude'].flat_map { |path| Dir.glob(path) }
      end

      def configuration_file
        @configuration_file ||= File.exist?('.rubocop.yml') ? YAML::load(File.open('.rubocop.yml')) : {}
      end

      def binary_exists?
        !Phare.system_output('which rubocop').empty?
      end

      def print_banner
        Phare.banner 'Running Rubocop to check for Ruby style…'
      end
    end
  end
end
