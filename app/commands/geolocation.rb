class GeolocationCommand < BaseCommand
  def initialize(args)
    if args.is_a? Hash
      self.latitude = args[:latitude]
      self.longitude = args[:longitude]
    elsif args.is_a? String
      if matches = args.match(/^(?<latitude>-?[\d\.]+)\s*,\s*(?<longitude>-?[\d\.]+)$/)
        self.latitude = matches[:latitude]
        self.longitude = matches[:longitude]
      else
        @address = args
      end
    end
  end

  def address
    @address
  end

  def latitude=(lat)
    @latitude = lat
  end

  def latitude
    @latitude
  end

  def longitude=(lon)
    @longitude = lon
  end

  def longitude
    @longitude
  end

  def should_geocode?
    !@address.nil? && latitude.nil? && longitude.nil?
  end

  def valid?
    !latitude.nil? && !longitude.nil?
  end

  def geocode
    results = Geocoder.search(@address)
    if results.count > 0
      self.latitude = results.first.latitude
      self.longitude = results.first.longitude
    end
    valid?
  end

  def process
    geocode if should_geocode?

    if valid?
      response = StationToStation::Connection.get('/stations/nearest', {
        latitude: latitude,
        longitude: longitude,
        limit: 3
      })

      if response && (json = Array(JSON.parse(response))) && json.count > 0
        self.response_text = "Stations near _#{address}_:"
        self.response_attachments = json.map{|station| station_data_to_attachment(station)}
      else
        self.response_text = "No stations found near '#{@address}'"
      end
    else
      self.response_text = "Invalid input '#{@address}'"
    end
  end

  private
  def validate_station_data(data)
    data.is_a?(Hash) &&
      data.key?('availability') &&
      data['availability'].is_a?(Hash) &&
      data['availability'].key?('bikes') &&
      data['availability'].key?('docks') &&
      data.key?('name')
  end

  def station_data_to_attachment(data)
    if validate_station_data(data)
      num_bikes = data['availability']['bikes'].to_i
      num_docks = data['availability']['docks'].to_i
      if num_bikes < 4 || num_docks < 4
        color = "#a6364f"
      elsif num_bikes < 6 || num_docks < 6
        color = "#a6a64f"
      else
        color = "#36a64f"
      end
      address = data['name']
      {
        text: "#{num_bikes} bikes, #{num_docks} docks @ *#{address}*",
        color: color,
        markdwn_in: ['text']
      }
    end
  end
end
