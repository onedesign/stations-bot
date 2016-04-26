class User < Sequel::Model
  def before_create
    self.created_at = Time.now
    self.num_requests = 0
    super
  end

  def before_update
    self.updated_at = Time.now
    super
  end

  def self.find_or_create_from_params(params)
    User.find_or_create({
      user_id: params['user_id']
    }){|u|
      data = safe_params(params)
      team = Team.where(team_id: params['team_id']).first
      data[:team_id] = team.id unless team.nil?
      u.set(data)
    }
  end

  def touch
    self.update(num_requests: (self.num_requests || 0) + 1)
  end

  private
    def self.safe_params(params)
      Hash[User.columns.select{|k| ![:id, :team_id].include?(k)}.map{|key| [key, params[key.to_s]]}]
    end
end
