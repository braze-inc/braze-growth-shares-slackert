# Slackert

A simple way to create and send Slack messages through a webhook.

Especially useful for logging and alerting, supports three logging levels `Error, Info, Debug` and templates to simplify sending the same layout message with different content.

## Installation

Add Slacker to your Gemfile

    gem 'slackert'

Then

    $ bundle install

Or install it yourself as:

    $ gem install slackert

## Usage

Slackert sends messages through an Incoming Webhook. To add a webhook to your channel, follow [this guide.](https://api.slack.com/messaging/webhooks)

Initialize alert client that will handle sending out your messages:

    alerts = Slackert::Alerter.new(<WebhookURL>)

Create a message with a message builder:

    message_builder = Slackert::MessageBuilder.new
    message_builder.add_header('Message Title')
    message_builder.add_plain_text('Description of the message.)
    message = message_builder.build

And send it out:

    alerts.info(message)

For more complex layouts, use `Blocks`.

### Message Building

We can also use a block initialization to simplify the process of creating a message

    message = Slackert::MessageBuilder.build do |msg|
      msg.add_header("Header)
      msg.add_markdown_text("This is some *bold* text while _this_ is italics. :thumbsup:")
      msg.add_divider

      msg.notifiy_users(
        ['slackMemberID1', 'slackMemberID2'],
        msg_prefix = 'Look at my message guys, '
      )

Include any emojis, styling you want. Go wild!

### Blocks

Slack messages use blocks to group and style messages. Blocks allow to include pictures, buttons,
interactivity and more.

The blocks currently supported by slackert: `Divider, Header, Section`

You can add a divider or a header directly from the builder:

    builder.add_header('Header Text')

    builder.add_divider

In order to compose a section block, use `Slackert::Blocks::Section`

    stats_section = Slackert::Blocks::Section.new

    # Add section text - description like text, limited to only one per section
    stats_section.add_section_text("The script executed with the following output:")

    # Add field text - it is like a cell in an invisible 2-column grid on Desktop and 1-column grid one Mobile
    stats_section.add_field_text("*Processed*:\n12345")
    stats_section.add_field_text("*Failed Records*:\n3")

Then simply add it to the builder:

    builder.add_section(stats_section)

We can also create a section straight from a hash of values, which simplifies creating sections for key: value type of data.

    values = {
        'Rows': 123,
        'Tables': 2
    }
    section = Slackert::Blocks::Section.new_from_hash(values, bold_keys: true)

### Templates

Templates optimize the process of creating and sending alerts by providing layouts and an easy way to fill their content. As an example, to send a Slack message when a job finishes processing:

    message = Slackert::Templates.job_finish(
        title: "My Job Title",
        desc: "The job is responsible for some real heavy work.",
        result: "OK :thumbsup:",
        stats: {
            "Processed Rows": 10987,
            "Updated Rows": 89,
            "Deleted Rows": 0,
            "Errors": 0
        }
    )

    alerts.info(message)

#### Examples

#### Job Executed

<br>
<img src="https://raw.githubusercontent.com/braze-inc/braze-growth-shares-slackert/master/screenshots/job-executed.png" width="600" height="309">
<br>

#### Job Error

<br>
<img src="https://raw.githubusercontent.com/braze-inc/braze-growth-shares-slackert/master/screenshots/job-error.png" width="600" height="281">
<br>

### Logging Level

To change the logging/reporting level, simply set `Slackert.level`.  
For example, to only report errors:

    Slackert.level = Slackert::Level::ERROR

By default, slackert starts with level `INFO`

<!-- ## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org). -->

<!-- ## Contributing

Bug reports and pull requests are welcome on GitHub at # repo link -->

# License

MIT. See [LICENSE](LICENSE)
