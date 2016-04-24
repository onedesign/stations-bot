require File.expand_path('../test_helper.rb', __FILE__)

class SavePlaceCommandTest < StationsBotTestBase

  def test_matches_save_place_command
    post '/v1/', slack_params.merge(text: 'set placename 1 n state st, 60657')
    assert_response_format JSON.parse(last_response.body)
  end

end
