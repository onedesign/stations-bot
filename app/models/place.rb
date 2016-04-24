class Place < Sequel::Model
  def validate
    super
    [:latitude, :longitude, :name].each do |key|
      errors.add(key, 'is required') if !self.send(key)
    end
  end

  def before_create
    self.created_at = Time.now
    self.num_requests = 0
    super
  end

  def before_update
    self.updated_at = Time.now
    super
  end

  def geocode
    unless self.query.empty?
      results = Geocoder.search(self.query)
      if results.count > 0
        self.latitude = results.first.latitude
        self.longitude = results.first.longitude
      end
    end
  end

end
