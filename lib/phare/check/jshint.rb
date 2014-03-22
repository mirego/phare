# encoding: utf-8
module Phare
  class Check
    class JSHint < Check
      attr_reader :config, :path

      def initialize(directory)
        @config = File.expand_path("#{directory}.jshintrc", __FILE__)
        @path = File.expand_path("#{directory}app/assets/javascripts", __FILE__)
        @glob = File.join(@path, '**/*')
      end

      def command
        "jshint --config #{@config} --extra-ext .js,.es6.js #{@glob}"
      end

    protected

      def should_run?
        !Phare.system_output('which jshint').empty? && File.exists?(@config) && Dir.exists?(@path)
      end

      def print_banner
        Phare.puts '---------------------------------------------'
        Phare.puts 'Running JSHint to check for JavaScript style…'
        Phare.puts '---------------------------------------------'
      end
    end
  end
end
