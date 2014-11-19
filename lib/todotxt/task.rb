require 'date'
require 'todotxt/relation'

module TodoTxt
  # A basic Todo.txt task
  # :priority The task priority
  # :created_at The created date for the task
  # :text The text for the task
  # :completed_at The completed date for the task
  # :contexts The contexts mentioned in the task
  # :projects The projects mentioned in the task
  Task = Relation.new(:priority, :created_at, :text, :completed_at) do
    PROJECTS = /(?:^| )\+(\S+)/
    CONTEXTS = /(?:^| )@(\S+)/
    COMPLETED_TASK = /^x (\d\d\d\d-\d\d-\d\d) (?:(\d\d\d\d-\d\d-\d\d) |)(.+)/
    PRIORITIZED_TASK = /^(?:\(([ABC])\) |)(?:(\d\d\d\d-\d\d-\d\d) |)(.+)/

    # Parses an existing Todo.txt task from a string
    # @param [String] raw the task string
    def self.parse(raw)
      args = {}
      args[:text] = raw
      if raw =~ COMPLETED_TASK
        args[:completed_at] = DateTime.parse($1)
        args[:created_at] = DateTime.parse($2) if $2
        args[:text] = $3
      else
        raw =~ PRIORITIZED_TASK
        args[:priority] = $1
        args[:created_at] = DateTime.parse($2) if $2
        args[:text] = $3
      end
      new(args)
    end

    def completed?
      !!completed_at
    end

    # Completes a task and sets the required dependencies
    def complete!
      self.completed_at ||= Time.now
    end

    def contexts
      Array(text.to_s.scan(CONTEXTS)).flatten
    end

    def projects
      Array(text.to_s.scan(PROJECTS)).flatten
    end

    def to_s
      ''.tap do |s|
        s << "x #{completed_at.strftime('%Y-%m-%d')} " if completed?
        s << "(#{priority}) " if priority
        s << "#{created_at.strftime('%Y-%m-%d')} " if created_at
        s << text.to_s
      end
    end
  end
end
