module StationsBot
  class OAuth < Grape::API
    version 'v1', :using => :path
    format :json

    get '/authorize' do
      auth_params = {
        client_id: ENV['SLACK_CLIENT_ID'],
        scope: 'commands',
        redirect_uri: ENV['SLACK_OAUTH_REDIRECT_URI']
      }.map{|k,v| "#{k}=#{v}"}.join('&')
      redirect "https://slack.com/oauth/authorize?#{auth_params}"
    end

    get '/authorize/callback' do
      if response = RestClient.get('https://slack.com/api/oauth.access', {
          params: {
            client_id: ENV['SLACK_CLIENT_ID'],
            client_secret: ENV['SLACK_CLIENT_SECRET'],
            code: params['code'],
            redirect_uri: ENV['SLACK_OAUTH_REDIRECT_URI']
          },
          content_type: :json,
          accept: :json
        })

        json = JSON.parse(response.body)
        if json.key?('access_token') && json.key?('team_id')
          team = Team.find_or_create(team_id: json['team_id'])
          data = {access_token: json['access_token']}
          data['team_name'] = json['team_name'] if json.key?('team_name')
          team.update(data)
          redirect "https://stationtostationapp.com/slack?success=true"
        else
          redirect "https://stationtostationapp.com/slack?success=false"
        end
      else
        redirect "https://stationtostationapp.com/slack?success=false"
      end
    end
  end
end
