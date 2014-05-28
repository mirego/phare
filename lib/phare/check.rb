module Phare
  class Check
    attr_reader :status, :command, :tree

    def initialize(_directory, options = {})
      @tree = Git.new(@extensions, options)
    end

    def run
      if should_run?
        print_banner
        Phare.system(command)
        @status = Phare.last_exit_status

        if @status == 0
          print_success_message
        else
          print_error_message
        end

        Phare.puts ''
      else
        @status = 0
      end
    end

    def should_run?
      should_run = binary_exists?

      [:configuration_exists?, :arguments_exists?].each do |condition|
        should_run &&= send(condition) if respond_to?(condition, true)
      end

      if @options[:diff]
        should_run &&= @tree.changed?
      end

      should_run
    end

  protected

    def print_success_message
      Phare.puts('Everything looks good from here!')
    end

    def print_error_message
      Phare.puts("Something went wrong. Program exited with #{@status}.")
    end
  end
end
