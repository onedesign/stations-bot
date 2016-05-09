class ListPlacesCommand < BaseCommand
  def initialize(user)
    @user = user
  end

  def process
    if @user && (places = Place.where(user_id: @user.id).all) && places.length > 0
      self.response_text = "Your saved places:"
      self.response_attachments = places.map do |place|
        {
          text: "*#{place.name}:* #{place.query}",
          mrkdwn_in: ['text']
        }
      end
    else
      self.response_text = "No places saved"
    end
  end
end
