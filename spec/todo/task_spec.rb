require 'spec_helper'
require 'todotxt/task'

module TodoTxt
  describe Task do
    describe 'complete!' do
      let(:todo) { Task.new }

      it 'marks the task as completed' do
        expect(todo).to_not be_completed
        todo.complete!
        expect(todo).to be_completed
      end

      it 'marks the task with a completed_at date' do
        expect(todo.completed_at).to be_nil
        todo.complete!
        expect(todo.completed_at).to be
      end
    end

    describe 'parse' do
      context 'completed' do
        let(:complete) { [
          'x 2011-03-03 Call Mom',
          'x 2011-03-03 2011-03-02 Call Mom'
        ] }

        let(:incomplete) { [
          'Call Mom',
          'X 2011-03-02 Call Mom',
          'X Really gotta call Mom (A) @phone @someday',
        ] }

        it 'parses completed tasks' do
          complete.each do |t|
            expect(Task.parse(t)).to be_completed
          end
        end

        it 'parses incomplete tasks' do
          incomplete.each do |t|
            expect(Task.parse(t)).to_not be_completed
          end
        end
      end

      context 'completed_at' do
        let(:complete) { [
          'x 2011-03-03 Call Mom',
          'x 2011-03-03 2011-03-02 Call Mom'
        ] }

        let(:incomplete) { [
          'Call Mom',
          'X 2011-03-02 Call Mom',
          'X Really gotta call Mom (A) @phone @someday',
        ] }

        it 'parses completed_at for completed tasks' do
          complete.each do |t|
            expect(Task.parse(t).completed_at).to eq(DateTime.parse('2011-03-03'))
          end
        end

        it 'ignores completed_at for incomplete tasks' do
          incomplete.each do |t|
            expect(Task.parse(t).completed_at).to be_nil
          end
        end
      end

      context 'priority' do
        let(:tasks_with) { [
          '(A) Call Mom',
          '(A) 2011-03-02 Call Mom'
        ] }

        let(:tasks_without) { [
          'Call Mom',
          '2011-03-02 Call Mom',
          'Really gotta call Mom (A) @phone @someday',
          '(b) Get back to the boss',
          '(B)->Submit TPS report'
        ] }

        it 'parses valid priority' do
          tasks_with.each do |t|
            expect(Task.parse(t).priority).to eq('A')
          end
        end

        it 'ignores invalid priority' do
          tasks_without.each do |t|
            expect(Task.parse(t).priority).to be_nil
          end
        end
      end

      context 'created_at' do
        let(:tasks_with) { [
          '2011-03-02 Document +TodoTxt task format',
          '(A) 2011-03-02 Call Mom'
        ] }

        let(:tasks_without) { [
          '(A) Call Mom 2011-03-02'
        ] }

        it 'parses valid created_at' do
          tasks_with.each do |t|
            expect(Task.parse(t).created_at).to eq(DateTime.parse('2011-03-02'))
          end
        end

        it 'ignores invalid created_at' do
          tasks_without.each do |t|
            expect(Task.parse(t).created_at).to be_nil
          end
        end
      end

      context 'context and project' do
        let(:tasks_with) { [
          '(A) Call Mom +Family +PeaceLoveAndHappiness @iphone @phone'
        ] }

        let(:tasks_without) { [
          'Email SoAndSo at soandso@example.com',
          'Learn how to add 2+2'
        ] }

        it 'parses valid context' do
          tasks_with.each do |t|
            expect(Task.parse(t).contexts).to eq(%w(iphone phone))
          end
        end

        it 'parses valid project' do
          tasks_with.each do |t|
            expect(Task.parse(t).projects).to eq(%w(Family PeaceLoveAndHappiness))
          end
        end

        it 'ignores invalid context' do
          tasks_without.each do |t|
            expect(Task.parse(t).contexts).to be_empty
          end
        end

        it 'ignores invalid project' do
          tasks_without.each do |t|
            expect(Task.parse(t).projects).to be_empty
          end
        end
      end

      it 'parses text' do
        text = 'Call Mom +Family +PeaceLoveAndHappiness @iphone @phone'
        [
          "(A) 2011-03-02 #{text}",
          "(A) #{text}",
          text
        ].each do |raw|
          expect(Task.parse(raw).text).to eq(text)
        end
      end
    end
  end
end
