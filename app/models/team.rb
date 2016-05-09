class Team < Sequel::Model
  def before_create
    self.created_at = Time.now
    super
  end

  def before_update
    self.updated_at = Time.now
    super
  end
end
