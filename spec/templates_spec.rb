require 'slackert'

RSpec.describe Slackert::Templates do
  describe '.job_start' do
    it 'creates a job start alert with all fields' do
      t = Slackert::Templates.job_start(
        title: 'Title',
        desc: 'Some desc',
        overview: {
          'key': 'value'
        }
      )
      puts t
      expect(t).not_to be_empty
      expect(t).to include(:blocks)
      # Header, desc, divider, fields
      expect(t[:blocks].length).to eq(4)
    end
  end

  describe '.job_finish' do
    it 'creates a job finish alert with all fields' do
      t = Slackert::Templates.job_finish(
        title: 'Title',
        desc: 'Description',
        result: 'a OK',
        stats: {
          'int_stat': 123
        }
      )
      expect(t).not_to be_empty
    end
  end

  describe '.job_executed' do
    it 'creates a job executed alert with omitting overview' do
      t = Slackert::Templates.job_executed(
        title: 'Title',
        desc: 'Funky little desc',
        result: ':thumbsup:',
        stats: {
          'cool stat': 'even cooler value'
        }
      )
      expect(t).not_to be_empty
    end
  end

  describe '.job_error' do
    it 'creates an error alert with all fields' do
      t = Slackert::Templates.job_error(
        title: 'Uhoh',
        error: 'test.rb:78 Silly error',
        notify_user_ids: ['userID1', 'userID2'],
        extra: {
          'Retries': 999
        }
      )
      expect(t).not_to be_empty
    end
  end
end
