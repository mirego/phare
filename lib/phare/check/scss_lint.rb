module Phare
  class Check
    class ScssLint < Check
      attr_reader :path

      def initialize(directory)
        @path = File.expand_path("#{directory}app/assets/stylesheets", __FILE__)
        @command = "scss-lint #{@path}"
      end

      def run
        if should_run?
          print_banner
          Phare.system(@command)
          @status = Phare.last_exit_status

          if @status == 0
            Phare.puts 'No code style errors found.'
          else
            Phare.puts "Something went wrong. Program exited with #{@status}"
          end

          Phare.puts ''
        else
          @status = 0
        end
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
