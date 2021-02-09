# frozen_string_literal: true

require 'slackert/blocks'

module Slackert
  # Pre-defined Slack message templates that you can use for a quick message layout
  # instead of building one from scratch. Most of the templates are customizable and you can
  # include or exclude fields like title, description or extra data that will appear in the message.
  #
  # Example Usage
  #
  #   message = Slackert::Templates.job_start(
  #     title: 'Job Title',
  #     desc: 'This job does this and that',
  #     overview: {
  #       'Job Type': 'Refresh',
  #       'Action': 'Update',
  #       'Start Time': Time.now.strftime("%Y/%m/%d %H:%M:%S")
  #     }
  #   )
  #
  #   alerts = Slackert::Alerter.new('mywebhook')
  #   alerts.info(message)
  #
  module Templates
    # Message layout for a quick notification.
    #
    # @param title [String] optional title
    # @param text [String] notification text, accepts markdown
    #
    # @return [Hash] Slack message
    #
    def self.notification(text:, title: '')
      MessageBuilder.build do |alert|
        alert.add_header(title) unless title.empty?
        alert.add_markdown_text(text)
      end
    end

    # Message layout to notify of a job start.
    #
    # @param title [String] title of the message, plain text only
    # @param desc [String] description of the message, accepts markdown
    # @param overview [Hash] extra identifiable key: value section fields to be included in the message,
    #                        both keys and values accept markdown and keys are bold by default
    # @return [Hash] Slack message
    #
    def self.job_start(
      title: '',
      desc: '',
      overview: {}
    )
      MessageBuilder.build do |alert|
        alert.add_header(title) unless title.empty?
        alert.add_plain_text(desc) unless desc.empty?
        add_section_from_hash(alert, overview) unless overview.empty?
      end
    end

    # Message layout to notify of a job finish.
    #
    # @param title [String] title of the message, plain text only
    # @param desc [String] description of the message, accepts markdown
    # @param result [String] result of the job, accepts markdown
    # @param stats [Hash] extra execution key: value section fields to be included in the message,
    #                     both keys and values accept markdown and keys are bold by default
    # @return [Hash] Slack message
    #
    def self.job_finish(
      title: '',
      desc: '',
      result: '',
      stats: {}
    )
      MessageBuilder.build do |alert|
        alert.add_header(title)
        alert.add_plain_text(desc)
        alert.add_markdown_text("*Result*: #{result}")
        add_section_from_hash(alert, stats) unless stats.empty?
      end
    end

    # Combines both job start and job finish into a single message. Best for quick jobs where a separate start
    # and finish alerts are unnecessary.
    #
    # @param title [String] title of the message, plain text only
    # @param desc [String] description of the message, accepts markdown
    # @param result [String] result of the job, accepts markdown
    # @param overview [Hash] a section of key: value fields, both keys and values accept markdown
    #                        and keys are bold by default
    # @param stats [Hash] a separate section of key: value fields, both keys and values accept markdown
    #                     and keys are bold by default
    # @return [Hash] Slack message
    #
    def self.job_executed(
      title: '',
      desc: '',
      result: '',
      overview: {},
      stats: {}
    )
      MessageBuilder.build do |alert|
        alert.add_header(title) unless title.empty?
        alert.add_plain_text(desc) unless desc.empty?
        alert.add_markdown_text("*Result*: #{result}") unless result.empty?
        add_section_from_hash(alert, overview) unless overview.empty?
        add_section_from_hash(alert, stats) unless stats.empty?
      end
    end

    # Message on job error that notifies specified users by tagging them in the alert.
    #
    # @param title [String] title of the job/alert, plain text only
    # @param error [String] error message
    # @param notify_user_ids Array<String> Slack member IDs that will be tagged and notified
    # @param extra [Hash] additional section of key: value fields, both accept markdown and keys are bold by default
    # @param add_alert_emoji [Boolean] adds rotating light emoji in the title
    #
    # @return [Hash] Slack message
    #
    def self.job_error(
      title:,
      error:,
      notify_user_ids: [],
      extra: {},
      add_alert_emoji: true
    )
      MessageBuilder.build do |alert|
        header = "Error while processing #{title}"
        header = add_alert_emoji ? ":rotating_light: #{header}" : header

        alert.add_header(header)
        alert.notify_users(notify_user_ids) unless notify_user_ids.empty?
        alert.add_divider
        alert.add_markdown_text('*Result*: Fail')
        alert.add_markdown_text("*Error Output*:\n```#{error}```")
        add_section_from_hash(alert, extra) unless extra.empty?
      end
    end

    def self.add_section_from_hash(alert, values)
      alert.add_divider
      section = Blocks::Section.new_from_hash(values, bold_keys: true)
      alert.add_section(section)
    end

    private_class_method :add_section_from_hash
  end
end
