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
        self.response_text = station_data_to_string(json.shift)
        alternates = json.map{|d| station_data_to_string(d)}
        self.response_attachments = alternates.count > 0 ? ["Alternates:\n" + alternates.join("\n")] : []
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

  def station_data_to_string(data)
    if validate_station_data(data)
      num_bikes = data['availability']['bikes'].to_i
      num_docks = data['availability']['docks'].to_i
      address = data['name']
      "#{num_bikes} bikes, #{num_docks} docks @ #{address}"
    end
  end
end
