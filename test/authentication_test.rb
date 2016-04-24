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

  def test_unrecognized_user_created_on_request
    params = slack_params
    params[:token] = ENV['SLACK_APPLICATION_TOKEN']
    user_id = params[:user_id]
    post '/v1/', params
    user = User.where(user_id: user_id).first
    refute user.nil?
    assert_equal user.user_id, user_id
  end

  def test_recognized_user_found_on_request
    user = User.create(user_id: random_string)
    num_requests = user.num_requests
    updated_at = user.updated_at
    post '/v1/', slack_params.merge(user_id: user.user_id)
    user.refresh
    assert_equal num_requests + 1, user.num_requests
    refute_equal updated_at, user.updated_at
  end
end
