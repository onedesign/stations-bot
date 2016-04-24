module StationsBot
  class API < Grape::API
    version 'v1', :using => :path
    format :json

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      error!({ text: e.message }, 400)
    end

    rescue_from :all do |e|
      error!({text: "Unknown error #{e.message}"}, 500)
    end

    before do
      error!({text: 'Unauthorized'}, 401) unless authenticate
    end

    after do
      user.touch
    end

    params do
      requires :token, :user_id
      optional :text, :team_id, :team_domain, :user_name
    end

    helpers do
      def authenticate
        params['token'] == ENV['SLACK_APPLICATION_TOKEN']
      end

      def args
        params['text'].strip unless params.nil? || params['text'].nil?
      end

      def user
        @user ||= User.find_or_create_from_params(params)
      end

      def build_command
        if args.nil? || args =~ /^help$/i
          HelpCommand.new
        elsif SavePlaceCommand.matches args
          SavePlaceCommand.new(user, args)
        else
          GeolocationCommand.new(args)
        end
      end
    end

    post '/' do
      if command = build_command
        command.process
        command.slackbot_response
      else
        {text: "Unknown command: '#{args}'"}
      end
    end
  end
end
