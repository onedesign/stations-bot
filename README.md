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

## Testing

Run test using:

```
rake test [test/path/to/test.rb]
```

## How it works

Slack sends all requests via a POST call to a single route. In our case, that route is `/v1/`.

One of the params Slack sends a `text`, which we use to understand the request.

For example, if text looks like geocoordinates, the app will create a GeolocationCommand with the coordinates,
and then send a request to Station to Station to find stations nearby, as well as their availability.

If the text is unmatched, or follows a format we don't quite understand, we attempt to geocode it.
If the geocoding is successful, we send the resulting lat/lon to Station to Station. Else, we respond with an error.
