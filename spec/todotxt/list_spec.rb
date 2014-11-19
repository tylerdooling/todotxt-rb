require 'spec_helper'
require 'todotxt/list'

module TodoTxt
  describe List do
    it 'is empty by default' do
      expect(List.new).to be_empty
    end

    it 'accepts a list of tasks' do
      tasks = [double]
      expect(List.new(tasks)).to_not be_empty
    end

    it 'is enumerable' do
      tasks = [double]
      list = List.new(tasks)
      expect { |block| list.each(&block) }.to yield_with_args(*tasks)
      expect { |block| list.map(&block) }.to yield_with_args(*tasks)
      expect { |block| list.select(&block) }.to yield_with_args(*tasks)
    end

    describe 'from_file' do
      let(:tasks) {
        <<-TASKS
(A) Call Mom +Family +PeaceLoveAndHappiness @iphone @phone
Email SoAndSo at soandso@example.com
Learn how to add 2+2
x 2011-03-03 Call Mom
x 2011-03-03 2011-03-02 Call Mom
Call Mom
X 2011-03-02 Call Mom
X Really gotta call Mom (A) @phone @someday
        TASKS
      }
      around do |example|
        `echo "#{tasks}" > /tmp/test-todo-task-list.txt`
        example.run
        `rm /tmp/test-todo-task-list.txt`
      end

      context 'when the file is empty' do
        it 'parses an empty list of tasks' do
          `touch /tmp/test-todo-task-list-empty.txt`
          expect(List.from_file(File.new('/tmp/test-todo-task-list-empty.txt')).size).to be(0)
        end
      end

      context 'when the file has tasks' do
        it 'parses a list of tasks from a file' do
          expect(List.from_file(File.new('/tmp/test-todo-task-list.txt')).size).to be(8)
        end
      end
    end

    describe 'to_file' do
      let(:tasks) {
        <<-TASKS
(A) Call Mom +Family +PeaceLoveAndHappiness @iphone @phone
Email SoAndSo at soandso@example.com
Learn how to add 2+2
x 2011-03-03 Call Mom
x 2011-03-03 2011-03-02 Call Mom
Call Mom
X 2011-03-02 Call Mom
X Really gotta call Mom (A) @phone @someday
        TASKS
      }
      before do
        `rm /tmp/test-todo-task-list.txt`
      end

      it 'writes the same content it reads (sanity check)' do
        input = StringIO.new(tasks)
        output = StringIO.new
        list = List.from_file(input)
        list.to_file(output)
        output.rewind
        expect(output.read).to eq(tasks.chomp)
      end
    end
  end
end
