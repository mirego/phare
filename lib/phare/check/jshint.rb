# encoding: utf-8
module Phare
  class Check
    class JSHint < Check
      attr_reader :config, :path

      def initialize(directory, options = {})
        @config = File.expand_path("#{directory}.jshintrc", __FILE__)
        @path = File.expand_path("#{directory}app/assets/javascripts", __FILE__)
        @glob = File.join(@path, '**/*')
        @extensions = %w(.js .es6.js)
        @options = options
      end

      def command
        if tree_changed?
          "jshint --config #{@config} --extra-ext #{@extensions.join(',')} #{tree_changes.join(' ')}"
        else
          "jshint --config #{@config} --extra-ext #{@extensions.join(',')} #{@glob}"
        end
      end

    protected

      def binary_exists?
        !Phare.system_output('which jshint').empty?
      end

      def configuration_exists?
        File.exists?(@config)
      end

      def arguments_exists?
        tree_changed? || Dir.exists?(@path)
      end

      def print_banner
        Phare.puts '---------------------------------------------'
        Phare.puts 'Running JSHint to check for JavaScript style…'
        Phare.puts '---------------------------------------------'
      end
    end
  end
end
