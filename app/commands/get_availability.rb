class GetAvailabilityCommand < GeolocationCommand
  def initialize(place)
    @place = place
  end

  def should_geocode?
    false
  end

  def valid?
    !@place.nil? && !@place.latitude.nil? && !@place.longitude.nil?
  end

  def station_to_station_params
    {
      latitude: @place.latitude,
      longitude: @place.longitude
    }
  end
  
  def process
    super
    @place.update(num_requests: @place.num_requests + 1)
  end
end
