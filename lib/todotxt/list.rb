require 'forwardable'
require 'todotxt/task'

module TodoTxt
  # Lists can be loaded from a file or instantiated in an empty state. They
  # behave likes arrays and the can be written to a file when you're
  # finished.
  class List
    include Enumerable
    extend Forwardable

    def_delegators :tasks, *(Array.instance_methods)

    # Parses a Todo.txt formatted file
    # @param [IO] file an IO input
    def self.from_file(file)
      tasks = file.readlines.map { |line|
        chomped = line.chomp
        Task.parse(chomped) unless chomped.empty?
      }.compact
      new tasks
    end

    # @param [Array<Task>] an array of tasks
    def initialize(tasks = [])
      @tasks = tasks
    end

    def each
      tasks.each { |t| yield t }
    end

    def to_s
      map(&:to_s).join("\n")
    end

    # Writes the list to a file
    # @param [IO] file an IO object
    def to_file(file)
      file.write(to_s)
    end

    private

    attr_reader :tasks
  end
end
