# TodoTxt

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
be parsed from an existing [todo.txt](http://todotxt.com) formatted task
or created from scratch.

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

## Contributing

1. Fork it ([https://github.com/tylerdooling/todotxt-rb/fork](https://github.com/tylerdooling/todotxt-rb/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
