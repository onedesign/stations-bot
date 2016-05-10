class RemovePlaceCommand < BaseCommand
  def initialize(user, args)
    @user = user

    matches = args.match(RemovePlaceCommand.regex)
    @name = matches[:name]
  end

  def place
    @place ||= Place.where(user_id: @user.id, name: @name).first
  end

  def place!
    @place ||= Place.new(user_id: @user.id, name: @name)
  end

  def process
    if place
      self.response_text = place.delete ? 
        "Successfully removed #{place.name}" :
        self.response_text = "There were errors removing your saved place #{place.errors.join(', ')}"
    else
      self.response_text = "Couldn't find a saved place with that name"
    end
  end

  def self.matches(args)
    !args.match(RemovePlaceCommand.regex).nil?
  end

  def self.regex
    /^remove (?<name>[A-Za-z0-9_-]+)$/
  end

end
