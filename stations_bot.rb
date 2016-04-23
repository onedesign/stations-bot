module StationsBot
  class API < Grape::API
    version 'v1', :using => :path
    format :json

    rescue_from :all do |e|
      error!('Unknown error', 500)
    end

    before do
      error!('Unauthorized', 401) unless authenticate
    end

    helpers do
      def authenticate
        params['token'] == ENV['SLACK_APPLICATION_TOKEN']
      end

      def args
        params['text'].strip unless params['text'].nil?
      end

      def build_command
        if args.nil? || args =~ /^help$/i
          HelpCommand.new
        elsif matches = args.match(/^(?<latitude>-?[\d\.]+)\s*,\s*(?<longitude>-?[\d\.]+)$/)
          GeolocationCommand.new(matches)
        end
      end
    end

    post '/' do
      if command = build_command
        command.fetch
        command.slackbot_response
      else
        {text: "Unknown command: '#{args}'"}
      end
    end
  end
end
