# frozen_string_literal: true

require 'slackert/blocks'

module Slackert
  # Builder class that allows to build a Slack message piece by piece.
  # After the message has been constructed, it is built with ++builder.build++ method and can be passed to Alerter 
  # class for sending.
  #
  # Supports blocks initialization that returns a ready alert/message
  #
  #   msg = Slackert::MessageBuilder.build do |b|
  #     b.add_header('header')
  #     ...
  #   end
  #
  class MessageBuilder
    # Block initialization
    # @return [Hash] built message
    #
    def self.build
      builder = new
      yield(builder)
      builder.build
    end

    def initialize
      @content = []
    end

    # Add a header to the message. It formats as a large title on top of the message.
    # @param text [String] header text, plain text only
    #
    def add_header(text)
      return if text.empty?

      @content.push(Blocks::Header.new(text).to_slack)
    end

    # Adds a horizontal divider.
    #
    def add_divider
      @content.push(Blocks::Divider.new.to_slack)
    end

    # Adds markdown text to the message.
    # @param text [String] markdown text
    #
    def add_markdown_text(text)
      return if text.empty?

      mkd_section = Blocks::Section.new
      mkd_section.add_field_text(text)
      add_section(mkd_section)
    end

    # Adds plain text to the message.
    # @param text [String] plain text
    #
    def add_plain_text(text)
      return if text.empty?

      text_section = Blocks::Section.new
      text_section.add_section_text(text)
      add_section(text_section)
    end

    # Adds Slack user notifications.
    # @param user_ids [Array<String>] Slack member IDs
    # @param msg_prefix [String] message added inline before the notifications
    # @param delim [String] delimiter to separate Slack users
    #
    def notify_users(user_ids, msg_prefix = 'Please look into this: ', delim = ' | ')
      return if user_ids.empty?

      tag_section = Blocks::Section.new
      user_notifs = user_ids.map { |user_id| "<@#{user_id}>" }
      notifs_msg = user_notifs.join(delim)
      tag_section.add_section_text(msg_prefix + notifs_msg)
      add_section(tag_section)
    end

    # Adds a {Blocks::Section} block element to the message.
    # @param section [Blocks::Section] section block
    #
    def add_section(section)
      @content.push(section.to_slack)
    end

    # Inserts a {Blocks::Section} block element on top of the message.
    # @param section [Blocks::Section] section block
    #
    def prepend_section(section)
      @content.unshift(section.to_slack)
    end

    # Builds a message. Creates a hash object from the added fields in the builder.
    # @return [Hash] Slack message
    #
    def build
      {
        'blocks': @content
      }
    end
  end
end
