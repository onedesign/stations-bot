class HelpCommand < BaseCommand
  def process
    @response_text = <<HELP_TEXT
Search for availability by address:
>   /stations 1 N State St, Chicago

Set your favorite locations by label:
>   /stations set work 1 N State St, Chicago
 
Get availability nearest your favorite locations by label:
>   /stations work

Get a list of your favorite stations by label:
>   /stations list

Get availability nearest your default location:
>   /stations set default work 1 N State St, Chicago
>   /stations
HELP_TEXT
  end
end
