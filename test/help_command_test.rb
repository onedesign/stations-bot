require File.expand_path('../test_helper.rb', __FILE__)

class HelpCommandTest < StationsBotTestBase

  def test_display_help_for_help_or_unknown_text_commands
    ((0..2).map{random_string} << 'help').each do |text|
      post '/v1/', slack_params.merge(text: text)
      assert_equal last_response.status, 201, "Help route did not respond: #{last_response.status}"
    end
  end

  def test_help_command_is_formatted_correctly
    post '/v1/', slack_params
    assert_response_format JSON.parse(last_response.body)
  end

end
