# encoding: utf-8
module Phare
  class Check
    class JSCS < Check
      attr_reader :config, :path

      def initialize(directory)
        @config = File.expand_path("#{directory}.jscs.json", __FILE__)
        @path = File.expand_path("#{directory}app/assets", __FILE__)
      end

      def command
        "jscs #{@path}"
      end

    protected

      def should_run?
        !Phare.system_output('which jscs').empty? && File.exists?(@config) && Dir.exists?(@path)
      end

      def print_banner
        Phare.puts '---------------------------------------------'
        Phare.puts 'Running JSCS to check for JavaScript style…'
        Phare.puts '---------------------------------------------'
      end
    end
  end
end
