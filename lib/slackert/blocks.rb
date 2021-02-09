# frozen_string_literal: true

module Slackert
  # Block elements that a Slack message can be composed of.
  module Blocks
    # Abstract BlockElement.
    # Subclass and override +to_slack+ to add a new block element.
    class BlockElement
      def initialize(type)
        @type = type
      end

      # Returns a hash of the element, ready to be added to the block formatted message.
      # Abstract method that needs to be implemented in each subclassed element.
      #
      def to_slack
        raise NoMethodError, 'Override this implementation'
      end
    end

    # Header block element provides a title, rendered as a larger bold text on top of the message.
    class Header < BlockElement
      # @param text [String] header text
      def initialize(text)
        super('header')
        @text = text
      end

      # See {BlockElement#to_slack}
      def to_slack
        {
          'type': @type,
          'text': {
            'type': 'plain_text',
            'text': @text
          }
        }
      end
    end

    # Divider block element provides a horizontal separator, simlarly to HTML's +<hr>+
    class Divider < BlockElement
      def initialize
        super('divider')
      end

      # See {BlockElement#to_slack}
      def to_slack
        {
          'type': @type
        }
      end
    end

    # Section block element is a very flexible layout block that can serve as a simple text block but it also allows
    # for adding block elements such as field text, buttons, images and more. Currently only section text and field
    # texts are supported.
    #
    # To learn more, visit https://api.slack.com/reference/block-kit/blocks#section
    #
    class Section < BlockElement
      def initialize
        @text = {}
        @fields = []
        super('section')
      end

      # Initialize field text objects from a hash.
      # @param [Hash] key, value pairs that each will become a field text object
      # @param line_break [Boolean] add a line break after each key so values render right under the key
      #                             instead of next to it
      # @param bold_keys [Boolean] apply bold text formatting to the keys
      # @return [Section]
      def self.new_from_hash(values, line_break: true, bold_keys: true)
        s = new

        values.each do |key, value|
          title = bold_keys ? "*#{key}*" : key
          title = line_break ? "#{title}\n" : title
          s.add_field_text("#{title}#{value}")
        end

        s
      end

      # Adds a text object on top of the section. There can only be one section text added. Adding more will replace
      # the previously added section text. It is limited to 3000 characters.
      # @param message [String] section text message
      # @param type [String] can be either mrkdwn or plain_text
      #
      def add_section_text(message, type = 'mrkdwn')
        @text = {
          'type': type,
          'text': message
        }
      end

      # Adds a field text object to the message. Field texts render in two columns on desktop and are added left
      # to right. They show as one column on mobile.
      # There can only be 10 fields added in total and each text item has a limit of 2000 characters.
      # @param message [String] field text message
      # @param type [String] can be either mrkdwn or plain_text
      # @raise [RuntimeError] if maximum capacity of 10 field objects has been reached
      #
      def add_field_text(message, type = 'mrkdwn')
        raise 'Maximum field text objects has been reached.' if @fields.length == 10

        @fields.push(
          {
            'type': type,
            'text': message
          }
        )
      end

      # See {BlockElement#to_slack}
      def to_slack
        if @text.empty? && @fields.empty?
          raise 'Either section text or field text needs to be filled in order to compose the section.'
        end

        section = { 'type': @type }
        section['text'] = @text unless @text.empty?
        section['fields'] = @fields unless @fields.empty?
        section
      end
    end
  end
end
