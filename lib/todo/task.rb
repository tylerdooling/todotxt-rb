require 'date'
require 'todo/relation'

module Todo
  Task = Relation.new(:priority, :created_at, :projects, :contexts, :text, :completed, :completed_at) do
    PRIORITY = /^\(([ABC])\) /
    DATE = /(\d\d\d\d-\d\d-\d\d) /
    CREATED_AT = /(?:#{PRIORITY}|^)#{DATE}/
    PROJECTS = /(?:^| )\+(\S+)/
    CONTEXTS = /(?:^| )@(\S+)/
    TEXT = /^(?:\([ABC]\) |)(?:\d\d\d\d-\d\d-\d\d |)(.+)/

    def self.parse(raw)
      created_at = (raw =~ CREATED_AT) && $2
      created_at = DateTime.parse(created_at) if created_at
      completed_at = (raw =~ /^x #{DATE}/) && $1
      completed_at = DateTime.parse(completed_at) if completed_at
      text = (raw =~ TEXT) && $1
      new(
        completed: !!(raw =~ /^x /),
        completed_at: completed_at,
        priority: (raw =~ PRIORITY) && $1,
        created_at: created_at,
        text: text,
        projects: Array(text.to_s.scan(PROJECTS)).flatten,
        contexts: Array(text.to_s.scan(CONTEXTS)).flatten
      )
    end

    def to_s
      ''.tap do |s|
        s << "(#{priority}) " if priority
        s << "#{created_at.strftime('%Y-%m-%d')} " if created_at
        s << text
      end
    end
  end
end
