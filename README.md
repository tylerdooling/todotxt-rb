# TodoTxt

[![Build Status](https://travis-ci.org/tylerdooling/todotxt-rb.svg)](https://travis-ci.org/tylerdooling/todotxt-rb)
[![Code Climate](https://codeclimate.com/github/tylerdooling/todotxt-rb/badges/gpa.svg)](https://codeclimate.com/github/tylerdooling/todotxt-rb)
[![Test Coverage](https://codeclimate.com/github/tylerdooling/todotxt-rb/badges/coverage.svg)](https://codeclimate.com/github/tylerdooling/todotxt-rb)

TodoTxt is a small ruby libary for easily interacting with [todo.txt](http://todotxt.com) formatted files.

## Installation

Add this line to your Gemfile:

```ruby
gem 'todotxt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install todotxt

## Usage

### Lists
Lists can be loaded from a file or instantiated in an empty state. They
behave likes arrays and the can be written to a file when you're
finished.

```ruby
# Load a list from a file
file = File.new('your_todos_file') 
list = TodoTxt::List.from_file(file) #=> accepts any IO

# Utilize enumerable behaviours
list.each { |todo| ... }
list.map { |todo| ... }
list.select { |todo| ... }

# Adding tasks
list.push task
list << task

# Deleting a task
list.delete task

# Persist to list to a file
list.to_file(file) #=> accepts any IO
```

### Tasks
Tasks are nothing more than a simple wrapper around a struct.  They can
be parsed from an existing [todo.txt formatted](https://github.com/ginatrapani/todo.txt-cli/wiki/The-Todo.txt-Format) task or created from scratch.

```ruby
# Parse a task
TodoTxt::Task.parse '(A) Call Mom +Family +PeaceLoveAndHappiness @iphone'
# Create a blank task
TodoTxt::Task.new 
# Create a task with attributes
TodoTxt::Task.new text: 'Call Mom'

# Complete a task
task.complete!
```

## Creating a [todo.txt](http://todotxt.com) add-on
[This page](https://github.com/ginatrapani/todo.txt-cli/wiki/Creating-and-Installing-Add-ons) provides basic documentation on creating todo.txt add-ons.
Below is a sample of what an addon can look like using this library.
If you're someone who uses todo.txt for task tracking throughout the
day, this add-on allows you to record tasks that are already completed.

```ruby
#!/usr/bin/env ruby

require 'todotxt'
require 'optparse'

if ARGV.size == 1 && ARGV.first == 'usage'
  puts <<-EOF
  Record completed task:
    report PRIORITY "THING I HAVE DONE ALREADY +project @context"
    report -o DATE PRIORITY "THING I HAVE DONE ALREADY +project @context"

  EOF
  exit
end

options = { date: Date.today }
OptionParser.new { |opts|
  opts.banner = "TODO"

  opts.on("-o", "--on [DATE]", "Date the task was completed") do |date|
    options[:date] = Date.parse date
  end
}.parse!

ARGV.shift #remove record
done_file = File.join(ENV['TODO_DIR'], 'done.txt')
current_done_tasks = File.read(done_file)

begin
  File.open(File.join(ENV['TODO_DIR'], 'done.txt'), 'r+') do |file|
    list = TodoTxt::List.from_file(file)
    task = TodoTxt::Task.parse(ARGV.join(' '))
    task.completed_at = options[:date]
    list << task
    file.rewind
    file.truncate(file.pos)
    list.to_file(file)
  end
  puts "Added completed task: #{task.to_s}"
rescue
  File.open(done_file, 'w') { |file| file.puts current_done_tasks }
  puts "Failed to add task - reverting"
  exit 1
end
```

## Alternatives
- [todo-txt-gem](https://github.com/samwho/todo-txt-gem)

## Contributing

1. Fork it ([https://github.com/tylerdooling/todotxt-rb/fork](https://github.com/tylerdooling/todotxt-rb/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
