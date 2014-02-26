module Phare
  module Checks
    class JavaScriptJSCS
      attr_reader :status

      def initialize(directory)
        @config = File.expand_path("#{directory}.jscs.json", __FILE__)
        @path = File.expand_path("#{directory}app/assets", __FILE__)
        @command = "jscs #{@path}"
      end

      def run
        if should_run?
          print_banner
          system(@command)
          @status = $CHILD_STATUS.exitstatus

          unless @status == 0
            puts "Something went wrong. Program exited with #{@status}"
          end

          puts ''
        else
          @status = 0
        end
      end

    protected

      def should_run?
        !`which jscs`.empty? && File.exists?(@config)
      end

      def print_banner
        puts '---------------------------------------------'
        puts 'Running JSCS to check for JavaScript style…'
        puts '---------------------------------------------'
      end
    end
  end
end
