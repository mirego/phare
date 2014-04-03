# encoding: utf-8
module Phare
  class Check
    class JSCS < Check
      attr_reader :config, :path

      def initialize(directory, options = {})
        @config = File.expand_path("#{directory}.jscs.json", __FILE__)
        @path = File.expand_path("#{directory}app/assets", __FILE__)
        @extensions = %w(.js)
        @options = options
      end

      def command
        if tree_changed?
          "jscs #{tree_changes.join(' ')}"
        else
          "jscs #{@path}"
        end
      end

    protected

      def binary_exists?
        !Phare.system_output('which jscs').empty?
      end

      def configuration_exists?
        File.exists?(@config)
      end

      def argument_exists?
        tree_changed? || Dir.exists?(@path)
      end

      def print_banner
        Phare.puts '---------------------------------------------'
        Phare.puts 'Running JSCS to check for JavaScript style…'
        Phare.puts '---------------------------------------------'
      end
    end
  end
end
