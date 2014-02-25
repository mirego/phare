module Phare
  module Checks
    class JavaScriptJSHint
      attr_reader :status

      def initialize(directory)
        @config = File.expand_path("#{directory}.jshintrc", __FILE__)
        @path = File.expand_path("#{directory}app/assets/javascripts/**/*", __FILE__)
        @command = "jshint --config #{@config} --extra-ext .js,.es6.js #{@path}"

        puts '---------------------------------------------'
        puts 'Running JSHint to check for JavaScript style…'
        puts '---------------------------------------------'
      end

      def run
        if File.exists?(@config)
          system(@command)
          @status = $CHILD_STATUS.exitstatus

          if @status == 0
            puts 'No code style errors found.'
          else
            puts "Something went wrong. Program exited with #{@status}"
          end
        else
          puts 'No `.jshintrc` configuration file found. Skipping it.'
          @status = 0
        end
      end
    end
  end
end
