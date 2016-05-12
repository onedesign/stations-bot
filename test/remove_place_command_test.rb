require File.expand_path('../test_helper.rb', __FILE__)

class RemovePlaceCommandTest < StationsBotTestBase

  def test_remove_with_invalid_places
    params = slack_params
    _send params.merge(text: 'set work 1 n state st, chicago')
    count = Place.count

    _send params.merge(text: 'remove')
    new_count = Place.count
    assert_equal count, new_count, "Empty remove command still deleted a place: #{last_response.body}"

    _send params.merge(text: 'remove placename')
    new_count = Place.count
    assert_equal count, new_count, "Invalid remove command still deleted a place: #{last_response.body}"
  end

  def test_removes_saved_place
    params = slack_params
    _send params.merge(text: 'set work 1 n state st, chicago')
    count = Place.count
    _send params.merge(text: 'remove work')
    new_count = Place.count
    assert_equal count - 1, new_count, "Failed to remove place: #{last_response.body}"
  end

end
