require 'slackert'

RSpec.describe Slackert, '.level' do
  it 'disallows out of bounds level' do
    expect { Slackert.level = 10 }.to raise_error(ArgumentError)
  end
end
