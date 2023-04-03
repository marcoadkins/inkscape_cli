# frozen_string_literal: true

module InkscapeCLI
  class Command
    attr_reader :executable, :args, :timeout

    def self.new(*args)
      instance = super(*args)

      if block_given?
        yield instance
        instance.execute
      else
        instance
      end
    end

    def initialize(executable = 'inkscape', timeout: 300)
      @executable = 'inkscape'
      @args = []
      @timeout = timeout
    end

    def execute
      Open3.popen3(executable, *args) do |_stdin, stdout, stderr, thread|
        [stdout, stderr].each(&:binmode)
        stdout_reader = Thread.new { stdout.read }
        stderr_reader = Thread.new { stderr.read }

        unless thread.join(timeout)
          Process.kill("TERM", thread.pid) rescue nil
          Process.waitpid(thread.pid) rescue nil
          raise Timeout::Error, "Inkscape command timed out..."
        end

        exit_status = thread.value.exitstatus
        if exit_status != 0
          raise InkscapeCli::Error,
                "Inkscape command failed with status: #{exit_status} and error: #{stderr_reader.value}"
        end

        [stdout_reader.value, stderr_reader.value, exit_status]
      end
    end

    def input_file(file)
      self << file
      self
    end

    alias_method :input_file=, :input_file

    def <<(arg)
      args << arg.to_s
      self
    end

    def method_missing(name, *args)
      option = "--#{name.to_s.tr('_', '-').gsub('=', '')}"
      self.args << option
      args.each do |arg|
        self.args << arg.to_s
      end
      self
    end
  end
end
