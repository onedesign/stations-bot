class GeolocationCommand < BaseCommand
  def initialize(data)
    @latitude = data[:latitude]
    @longitude = data[:longitude]
  end

  def fetch
    response = StationToStation::Connection.get('/stations/nearest', {
      latitude: @latitude,
      longitude: @longitude,
      limit: 3
    })

    if response && (json = Array(JSON.parse(response))) && json.count > 0
      self.response_text = station_data_to_string(json.shift)
      alternates = json.map{|d| station_data_to_string(d)}
      self.response_attachments = alternates.count > 0 ? ["Alternates:\n" + alternates.join("\n")] : []
    else
      self.response_text = "Error getting availability data"
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
