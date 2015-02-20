# encoding: utf-8
module Phare
  class Check
    class JSHint < Check
      attr_reader :config, :path

      def initialize(directory, options = {})
        @config = File.expand_path("#{directory}.jshintrc", __FILE__)
        @path = File.expand_path("#{directory}app/assets/javascripts", __FILE__)
        @glob = File.join(@path, '**/*')
        @extensions = %w(.js .es6)
        @options = options

        super
      end

      def command
        if @tree.changed?
          "jshint --config #{@config} --extra-ext #{@extensions.join(',')} #{@tree.changes.join(' ')}"
        else
          "jshint --config #{@config} --extra-ext #{@extensions.join(',')} #{@glob}"
        end
      end

    protected

      def excluded_files
        [] # TODO: Fetch the exclude list from .jshintignore
      end

      def binary_exists?
        !Phare.system_output('which jshint').empty?
      end

      def configuration_exists?
        File.exist?(@config)
      end

      def arguments_exists?
        @tree.changed? || Dir.exist?(@path)
      end

      def print_banner
        Phare.banner 'Running JSHint to check for JavaScript style…'
      end
    end
  end
end
