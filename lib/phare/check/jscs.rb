# encoding: utf-8
module Phare
  class Check
    class JSCS < Check
      attr_reader :config, :path

      def initialize(directory)
        @config = File.expand_path("#{directory}.jscs.json", __FILE__)
        @path = File.expand_path("#{directory}app/assets", __FILE__)
        @command = "jscs #{@path}"
      end

      def run
        if should_run?
          print_banner
          Phare.system(@command)
          @status = Phare.last_exit_status

          unless @status == 0
            Phare.puts "Something went wrong. Program exited with #{@status}"
          end

          Phare.puts ''
        else
          @status = 0
        end
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
