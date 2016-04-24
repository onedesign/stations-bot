require File.expand_path('../test_helper.rb', __FILE__)

class SavePlaceCommandTest < StationsBotTestBase

  def test_matches_save_place_command
    send slack_params.merge(text: 'set placename 1 n state st, 60657')
    assert_response_format JSON.parse(last_response.body)
  end

  def test_saves_new_place
    count = Place.count
    send slack_params.merge(text: 'set placename 1 n state st, chicago')
    assert_equal count + 1, Place.count, "Failed to save place: #{last_response.body}"
  end

end
