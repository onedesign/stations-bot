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
      u.set(safe_params(params))
    }
  end

  def touch
    self.update(num_requests: (self.num_requests || 0) + 1)
  end

  private
    def self.safe_params(params)
      Hash[User.columns.select{|k| k != :id}.map{|key| [key, params[key.to_s]]}]
    end
end
