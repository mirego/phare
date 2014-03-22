module Phare
  class Check
    class JSHint < Check
      attr_reader :config, :path

      def initialize(directory)
        @config = File.expand_path("#{directory}.jshintrc", __FILE__)
        @path = File.expand_path("#{directory}app/assets/javascripts", __FILE__)
        @glob = File.join(@path, '**/*')
        @command = "jshint --config #{@config} --extra-ext .js,.es6.js #{@glob}"
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
        !Phare.system_output('which jshint').empty? && File.exists?(@config) && Dir.exists?(@path)
      end

      def print_banner
        Phare.puts '---------------------------------------------'
        Phare.puts 'Running JSHint to check for JavaScript style…'
        Phare.puts '---------------------------------------------'
      end
    end
  end
end
