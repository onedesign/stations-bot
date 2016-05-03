# Station to Station Slackbot

This provides a few simple [Slack slash commands](https://api.slack.com/slash-commands)
for quickly checking bikeshare availability, wherever you need.

This uses data from [Station to Station](https://stationtostationapp.com), by [Peter Compernolle](https://github.com/thelowlypeon), with permission.

## Commands

### Help

```
/stations help

> Search for availability by address:
>   /stations 1 N State St, Chicago
> 
> Set your favorite locations by label:
>   /stations set work 1 N State St, Chicago
> 
> Get availability nearest your favorite locations by label:
>   /stations work
```

### Get station availability nearest an address

```
/stations 230 W Superior St, Chicago

9 bikes, 11 docks at Franklin St & Chicago Ave
> Alternates:
> 2 bikes, 14 docks at Wells St & Huron St
> 2 bikes, 17 docks at Sedgwick St & Huron St
```

### Set your favorite locations by label

```
/stations set work 230 W Superior St, Chicago

> Set "work" as "230 W Superior St, Chicago"
> Nearest station: Franklin St & Chicago Ave

/stations work

9 bikes, 11 docks at Franklin St & Chicago Ave
> Alternates:
> 2 bikes, 14 docks at Wells St & Huron St
> 2 bikes, 17 docks at Sedgwick St & Huron St
```

### List your favorite locations

```
/stations list

Your saved places:
> *work:* 230 W Superior St, Chicago
```

## Development

This is a mostly standard Rack application, but you'll need a few things:

1. Clone the repo
2. Create a local database
  * This can be MySQL, PostgeSQL, or Sqlite
  * See more about options in the [Sequel Docs](http://sequel.jeremyevans.net/rdoc/classes/Sequel.html#method-c-connect)
3. Define your environment variables in `.env`
  * Set `DATABASE_URL` according to your DB setup defined in step 2
  * If you're running the Station to Station API locally, set `STATION_TO_STATION_URL` to your localhost, else set it to `https://api.stationtostationapp.com`
  * You'll need a token to access the Station to Station API if it's not running locally. Contact @thelowlypeon for a token, or check the Heroku stations-bot settings for the production token
4. Run using the command `rackup`, or, if you need to define a port, eg 1234, `rackup -p 1234`

## Testing

Run test using:

```
rake test [test/path/to/test.rb]
```

## Production

This is currently running in a production environment on Heroku at [stations-bot.herokuapp.com](https://dashboard.heroku.com/apps/stations-bot/resources).

Because it's a rack application, you can't run some of the perhaps more familiar commands like `heroku run rails c`. 

Instead, if you need to use the console, do so as follows:

```
$ heroku run irb
irb(main):001:0> require './bootstrap.rb'
irb(main):001:0> User.count
=> 1238763485
```

## How it works

Slack sends all requests via a POST call to a single route. In our case, that route is `/v1/`.

One of the params Slack sends a `text`, which we use to understand the request.

For example, if text looks like geocoordinates, the app will create a GeolocationCommand with the coordinates,
and then send a request to Station to Station to find stations nearby, as well as their availability.

If the text is unmatched, or follows a format we don't quite understand, we attempt to geocode it.
If the geocoding is successful, we send the resulting lat/lon to Station to Station. Else, we respond with an error.
