require File.expand_path('../test_helper.rb', __FILE__)

class GeolocationCommandTest < StationsBotTestBase

  def test_matches_geolocation_request
    post '/v1/', slack_params.merge(text: '41.8764280000, -87.6203390000')
    assert_response_format JSON.parse(last_response.body)
  end

  def test_geolocation_returns_attachments
    post '/v1/', slack_params.merge(text: '41.8764280000, -87.6203390000')
    json = JSON.parse(last_response.body)
    assert json.key?('attachments')
    assert json['attachments'].is_a?(Array)
    assert json['attachments'].count > 0, "Geolocation request returned zero backup stations #{json}"
    json['attachments'].each do |attachment|
      assert attachment['text'] =~ /\d+ bike/
      assert attachment['text'] =~ /\d+ dock/
    end
  end

end
