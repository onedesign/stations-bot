require File.expand_path('../test_helper.rb', __FILE__)

class ListPlacesCommandTest < StationsBotTestBase

  def test_list_command_with_no_saved_places
    _send slack_params.merge(text: 'list')
    json = JSON.parse(last_response.body)
    assert json.key?('attachments'), "JSON has no attachments #{json}"
    assert json['attachments'].is_a?(Array)
    assert_equal json['attachments'].count, 0, "List command returned attachments, expecting none: #{json}"
  end

  def test_list_command_with_saved_places
    params = slack_params
    _send params.merge(text: 'set placename 1 n state st, chicago')
    _send params.merge(text: 'list')
    json = JSON.parse(last_response.body)
    assert json.key?('attachments'), "JSON has no attachments #{json}"
    assert json['attachments'].is_a?(Array)
    assert_equal json['attachments'].count, 1, "List command returned no attachments, expecting one: #{json}"
  end

end
