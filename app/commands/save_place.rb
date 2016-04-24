class SavePlaceCommand < BaseCommand
  def initialize(user, args)
    @user = user

    matches = args.match(SavePlaceCommand.regex)
    @name = matches[:name]
    @address = matches[:address]
  end

  def place
    @place ||= Place.where(user_id: @user.id, name: @name).first
  end

  def place!
    @place ||= Place.new(user_id: @user.id, name: @name)
  end

  def update_place
    place!.query = @address
    place.geocode if place.changed_columns.include?(:query)
  end

  def process
    new_record = place.nil?
    update_place
    if !place.modified?
      self.response_text = "No changes made to #{place.name}"
    elsif place.valid? && place.save
      self.response_text = new_record ?
        "Successfully set your new place '#{place.name}'" :
        "Successfully updated #{place.name}"
    else
      self.response_text = "There were errors saving your place #{p.errors.join(', ')}"
    end
  end

  def self.matches(args)
    !args.match(SavePlaceCommand.regex).nil?
  end

  def self.regex
    /^set (?<name>[A-Za-z0-9_-]+)\s*(?<address>.+)$/
  end

end
