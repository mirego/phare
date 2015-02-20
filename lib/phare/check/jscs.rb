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

        super
      end

      def command
        if @tree.changed?
          "jscs #{@tree.changes.join(' ')}"
        else
          "jscs #{@path}"
        end
      end

    protected

      def excluded_files
        [] # TODO: Fetch the exclude list from .jscs.json
      end

      def binary_exists?
        !Phare.system_output('which jscs').empty?
      end

      def configuration_exists?
        File.exist?(@config)
      end

      def argument_exists?
        @tree.changed? || Dir.exist?(@path)
      end

      def print_banner
        Phare.banner 'Running JSCS to check for JavaScript style…'
      end
    end
  end
end
