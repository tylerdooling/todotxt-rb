require 'date'
require 'todotxt/relation'

module TodoTxt
  Task = Relation.new(:priority, :created_at, :projects, :contexts, :text, :completed_at) do
    PROJECTS = /(?:^| )\+(\S+)/
    CONTEXTS = /(?:^| )@(\S+)/
    COMPLETED_TASK = /^x (\d\d\d\d-\d\d-\d\d) (?:(\d\d\d\d-\d\d-\d\d) |)(.+)/
    PRIORITIZED_TASK = /^(?:\(([ABC])\) |)(?:(\d\d\d\d-\d\d-\d\d) |)(.+)/

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
      args[:projects] = Array(args[:text].to_s.scan(PROJECTS)).flatten
      args[:contexts] = Array(args[:text].to_s.scan(CONTEXTS)).flatten
      new(args)
    end

    def completed?
      !!completed_at
    end

    def complete!
      self.completed_at ||= Time.now
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
