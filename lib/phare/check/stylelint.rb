# encoding: utf-8
module Phare
  class Check
    class Stylelint < Check
      GLOBAL_BINARY = 'stylelint'.freeze
      LOCAL_BINARY = 'node_modules/.bin/stylelint'.freeze

      attr_reader :config, :path

      def initialize(directory, options = {})
        @directory = directory
        @config = File.expand_path("#{directory}.stylelintrc", __FILE__)
        @path = File.expand_path("#{directory}app/assets/stylesheets", __FILE__)
        @extensions = %w(.scss)
        @options = options

        super
      end

      def command
        "#{binary} #{input}"
      end

    protected

      def configuration_exists?
        File.exist?(@config)
      end

      def binary
        local_binary_exists? ? @directory + LOCAL_BINARY : GLOBAL_BINARY
      end

      def binary_exists?
        local_binary_exists? || global_binary_exists?
      end

      def local_binary_exists?
        !Phare.system_output("which #{@directory}#{LOCAL_BINARY}").empty?
      end

      def global_binary_exists?
        !Phare.system_output("which #{GLOBAL_BINARY}").empty?
      end

      def input
        @tree.changed? ? files_to_check.join(' ') : "'#{@path}/**/*#{@extensions.first}'"
      end

      def arguments_exists?
        @tree.changed? || Dir.exist?(@path)
      end

      def print_banner
        Phare.banner 'Running Stylelint to check for SCSS style…'
      end
    end
  end
end
