# encoding: utf-8
module Phare
  class Check
    class ScssLint < Check
      attr_reader :path

      def initialize(directory)
        @path = File.expand_path("#{directory}app/assets/stylesheets", __FILE__)
      end

      def command
        "scss-lint #{@path}"
      end

    protected

      def should_run?
        !Phare.system_output('which scss-lint').empty? && Dir.exists?(@path)
      end

      def print_banner
        Phare.puts '------------------------------------------'
        Phare.puts 'Running SCSS-Lint to check for SCSS style…'
        Phare.puts '------------------------------------------'
      end
    end
  end
end
