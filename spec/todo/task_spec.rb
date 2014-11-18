require 'spec_helper'
require 'todo/task'

module Todo
  describe Task do
    let(:priority) { "(A) " }
    let(:created_at) { "2011-03-02 " }
    let(:text) { "Call Mom" }
    let(:raw) { "#{priority}#{created_at}#{text}" }
    let(:todo) { Todo::Task.parse raw }

    context 'when a priority exists' do
      let(:priority) { "(A) " }

      it 'parses it' do
        expect(todo.priority).to eq('A')
      end

      it 'writes it' do
        expect(todo.to_s).to match(PRIORITY)
      end
    end

    context 'when a priority does not exist' do
      let(:priority) { nil }

      it 'parses it' do
        expect(todo.priority).to be_nil
      end

      it 'writes it' do
        expect(todo.to_s).to_not match(PRIORITY)
      end
    end

    context 'when a created date exists' do
      let(:created_at) { "2011-03-02 " }

      it 'parses it' do
        expect(todo.created_at).to eq(DateTime.parse '2011-03-02')
      end

      it 'writes it' do
        expect(todo.to_s).to match(CREATED_AT)
      end
    end

    context 'when a created date does not exist' do
      let(:created_at) { nil }

      it 'parses it' do
        expect(todo.created_at).to be_nil
      end

      it 'writes it' do
        expect(todo.to_s).to_not match(CREATED_AT)
      end
    end

    context 'when projects are present' do
      let(:text) { "+project1 +Project2 Call Mom" }

      it 'parses them' do
        expect(todo.projects).to eq(%w(project1 Project2))
      end

      it 'writes them' do
        expect(todo.to_s).to match(PROJECTS)
      end
    end

    context 'when projects are not present' do
      let(:text) { "Call Mom" }

      it 'parses them' do
        expect(todo.projects).to be_empty
      end

      it 'writes them' do
        expect(todo.to_s).to_not match(PROJECTS)
      end
    end

    context 'when contexts are present' do
      let(:text) { "@context1 @Context2 Call Mom" }

      it 'parses them' do
        expect(todo.contexts).to eq(%w(context1 Context2))
      end

      it 'writes them' do
        expect(todo.to_s).to match(CONTEXTS)
      end
    end

    context 'when contexts are not present' do
      let(:text) { "Call Mom" }

      it 'parses them' do
        expect(todo.contexts).to be_empty
      end

      it 'writes them' do
        expect(todo.to_s).to_not match(CONTEXTS)
      end
    end

    it 'parses the text' do
      expect(todo.text).to eq(text)
    end

    it 'writes the text' do
      expect(todo.to_s).to match(/#{text}/)
    end
  end
end
