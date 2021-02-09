require 'slackert/alerter'
require 'slackert/level'
require 'slackert/builder'
require 'slackert/blocks'
require 'slackert/templates'

# Namespace for classes and modules that handle creation and delivery of Slack messages and alerts
module Slackert
  @level = Level::INFO

  # Sets logging level for messages. Logging level constants are defined in {Slackert::Level}
  #
  # @param level [Number] logging level
  # @raise [ArgumentError] if the logging level is out of bounds
  #
  def self.level=(value)
    log_values = Level.constants.map { |const| Level.const_get(const) }
    min, max = log_values.minmax
    raise ArgumentError, 'Invalid logging level' if value < min || value > max

    @level = value
  end

  # Return current logging level
  # @return [Number] current level
  #
  def self.level
    @level
  end
end
