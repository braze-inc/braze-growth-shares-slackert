# frozen_string_literal: true

require_relative 'lib/slackert/version'

Gem::Specification.new do |spec|
  spec.name          = 'slackert'
  spec.version       = Slackert::VERSION
  spec.authors       = ['Maciej Olko']
  spec.summary       = 'Quick and simple way to send message through Slack webhook.'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')
  spec.homepage      = 'https://github.com/braze-inc/braze-growth-shares-slackert'
  spec.license       = 'MIT'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rspec'
end
