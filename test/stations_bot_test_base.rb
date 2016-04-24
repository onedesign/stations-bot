class StationsBotTestBase < MiniTest::Test
  include Rack::Test::Methods

  def app
    StationsBot::API
  end

  def random_string(only_alphanum=true)
    character_set = [('a'..'z'), ('A'..'Z')] 
    character_set << " \"',./?[]{}-_=+".scan(/./) unless only_alphanum
    o = character_set.map{ |i| i.to_a }.flatten
    (0...50).map { o[rand(o.length)] }.join
  end

  def assert_response_format(json)
    assert json.key?('text'), "Response does not contain a text key: #{json.keys}"
    assert json['text'].is_a?(String), "Text value is not a string: #{json['text']}"
    if json.key?('attachments')
      assert json['attachments'].is_a? Array
      json['attachments'].each do |attachment|
        assert attachment.is_a?(Hash), "Attachment is not a valid hash: #{attachment}"
        assert attachment.key?('text'), "Attachment does not contain a text key: #{attachment}"
        assert attachment['text'].is_a?(String), "Attachments's text key is not a string: #{attachment['text']}"
      end
    end
  end

  def send(params)
    post '/v1/slackbot', params
  end

  def slack_params
    {
      token: 'TEST',
      team_id: random_string,
      team_domain: random_string,
      channel_id: random_string,
      channel_name: random_string,
      user_id: random_string,
      user_name: random_string,
      command: '/stations',
      text: random_string,
      response_url: 'https://hooks.slack.com/commands/1234/5678'
    }
  end
end
