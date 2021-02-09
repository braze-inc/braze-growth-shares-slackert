# frozen_string_literal: true

require 'uri'
require 'net/https'
require 'json'

module Slackert
  # Slack client responsible for sending composed Slack messages
  # @param [String] Slack incoming webhook URL to a particular channel
  #
  class Alerter
    def initialize(webhook_url)
      @uri = URI.parse(webhook_url)
      @https = configure_https
    end

    # Sends a debug Slack message if logging level is set at Level::DEBUG
    # @param [Hash] Slack message
    #
    def debug(content)
      return if Slackert.level < Level::DEBUG

      post_to_slack(content)
    end

    # Sends an info Slack message if loggin level is set at Level::INFO or lower
    # @param [Hash] Slack message
    #
    def info(content)
      return if Slackert.level < Level::INFO

      post_to_slack(content)
    end

    # Sends an error Slack message
    # @param [Hash] Slack message
    #
    def error(content)
      post_to_slack(content)
    end

    private

    def configure_https
      https = Net::HTTP.new(@uri.host, @uri.port)
      https.use_ssl = true
      https
    end

    def post_to_slack(content)
      raise 'Message content cannot be empty.' if content.empty?

      req = base_post_req
      req.body = content.to_json
      res = @https.request(req)
      puts "Message sending unsuccesful (Code: #{res.code}, Message: #{res.message})" if res.code != '200'
    end

    def base_post_req
      req = Net::HTTP::Post.new(@uri)
      req['Content-type'] = 'application/json'
      req
    end
  end
end
