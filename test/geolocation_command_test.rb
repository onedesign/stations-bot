require File.expand_path('../test_helper.rb', __FILE__)

class GeolocationCommandTest < StationsBotTestBase

  def test_matches_geolocation_request
    _send slack_params.merge(text: '41.8764280000, -87.6203390000')
    assert_response_format JSON.parse(last_response.body)
    assert_equal 2, last_response.status.to_s[0].to_i, "Geolocation request returned unsuccessful status #{last_response.body}"
  end

  def test_geolocation_returns_attachments
    _send slack_params.merge(text: '41.8764280000, -87.6203390000')
    json = JSON.parse(last_response.body)
    assert json.key?('attachments'), "JSON has no attachments #{json}"
    assert json['attachments'].is_a?(Array)
    assert json['attachments'].count > 0, "Geolocation request returned zero backup stations #{json}"
    json['attachments'].each do |attachment|
      assert attachment['text'] =~ /\d+ bike/
      assert attachment['text'] =~ /\d+ dock/
    end
  end

  def test_coordinate_arguments_avoid_geocoding
    cmd = GeolocationCommand.new('41.8764280000, -87.6203390000')
    assert cmd.valid?
    refute cmd.should_geocode?
  end

  def test_unmatched_string_arguments_require_geocoding
    cmd = GeolocationCommand.new('something else')
    refute cmd.valid?
    assert cmd.should_geocode?
  end

end
