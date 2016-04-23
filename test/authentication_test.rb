require File.expand_path('../test_helper.rb', __FILE__)

class AuthenticationTest < StationsBotTestBase

  def test_invalid_token_unauthorized
    post '/v1/', slack_params.merge(token: 'invalidtoken')
    assert_equal last_response.status, 401
  end

  def test_no_token_unauthorized
    params = slack_params.delete(:token)
    post '/v1/', params
    assert_equal last_response.status, 401
  end

  def test_valid_token_authorized
    post '/v1/', slack_params.merge(token: ENV['SLACK_APPLICATION_TOKEN'])
    refute last_response.status == 401
  end

end
