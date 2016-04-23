module StationToStation
  class Connection
    def self.get(route, options={})
      RestClient.get(base_url + route, {
        params: options.merge({token: auth_token}),
        content_type: :json,
        accept: :json
      })
    end

    private
    def self.auth_token
      @auth_token ||= ENV['STATION_TO_STATION_TOKEN']
    end

    def self.base_url
      @base_url ||= (ENV['STATION_TO_STATION_URL'] + '/v1')
    end
  end
end
