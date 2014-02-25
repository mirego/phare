module Phare
  module Checks
    class JavaScriptJSCS
      attr_reader :status

      def initialize(directory)
        @config = File.expand_path("#{directory}.jscs.json", __FILE__)
        @path = File.expand_path("#{directory}app/assets", __FILE__)
        @command = "jscs #{@path}"

        puts '---------------------------------------------'
        puts 'Running JSCS to check for JavaScript style…'
        puts '---------------------------------------------'
      end

      def run
        if File.exists?(@config)
          system(@command)
          @status = $CHILD_STATUS.exitstatus

          unless @status == 0
            puts "Something went wrong. Program exited with #{@status}"
          end
        else
          puts 'No `.jscs.json` configuration file found. Skipping it.'
          @status = 0
        end
      end
    end
  end
end
