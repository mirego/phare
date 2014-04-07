module Phare
  class Git
    def initialize(extensions, options)
      @extensions = extensions
      @options = options
    end

    def changed?
      @options[:diff] && changes.any?
    end

    def changes
      @changes ||= Phare.system_output('git status -s').split("\n").reduce([]) do |memo, diff|
        filename = diff.split(' ').last

        if diff =~ /^[^D]{2}/ && @extensions.include?(File.extname(filename))
          memo << filename
        end

        memo
      end
    end
  end
end
