module Phare
  module Checks
    class ScssLint
      attr_reader :status

      def initialize(directory)
        @path = File.expand_path("#{directory}app/assets/stylesheets", __FILE__)
        @command = "scss-lint #{@path}"
      end

      def run
        if should_run?
          print_banner
          system(@command)
          @status = $CHILD_STATUS.exitstatus

          if @status == 0
            puts 'No code style errors found.'
          else
            puts "Something went wrong. Program exited with #{@status}"
          end

          puts ''
        else
          @status = 0
        end
      end

    protected

      def should_run?
        !`which scss-lint`.empty? && Dir.exists?(@path)
      end

      def print_banner
        puts '------------------------------------------'
        puts 'Running SCSS-Lint to check for SCSS style…'
        puts '------------------------------------------'
      end
    end
  end
end
