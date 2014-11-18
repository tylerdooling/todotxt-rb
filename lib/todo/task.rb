require 'todo/relation'

module Todo
  Task = Relation.new(:priority, :created_at, :projects, :contexts, :text, :completed) do
    PRIORITY = /^\(([ABC])\) /
    CREATED_AT = /(?:#{PRIORITY}|^)(\d\d\d\d-\d\d-\d\d)/
    PROJECTS = /(?:^| )\+(\S+)/
    CONTEXTS = /(?:^| )@(\S+)/
    TEXT = /^(?:\([ABC]\) |)(?:\d\d\d\d-\d\d-\d\d |)(.+)/


    def self.parse(raw)
      created_at = (raw =~ CREATED_AT) && $2
      created_at = DateTime.parse(created_at) if created_at
      text = (raw =~ TEXT) && $1
      new(
        completed: (raw =~ /^x /) && true,
        priority: (raw =~ PRIORITY) && $1,
        created_at: created_at,
        text: text,
        projects: Array(text.scan(PROJECTS)).flatten,
        contexts: Array(text.scan(CONTEXTS)).flatten
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
