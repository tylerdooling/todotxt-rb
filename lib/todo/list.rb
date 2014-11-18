require 'forwardable'
require 'todo/task'

module Todo
  class List
    include Enumerable
    extend Forwardable

    def_delegators :tasks, *(Array.instance_methods)

    def self.from_file(file)
      tasks = file.readlines.map { |line|
        chomped = line.chomp
        Task.parse(chomped) unless chomped.empty?
      }.compact
      new tasks
    end

    def initialize(tasks = [])
      @tasks = tasks
    end

    def each
      tasks.each { |t| yield t }
    end

    private

    attr_reader :tasks
  end
end
