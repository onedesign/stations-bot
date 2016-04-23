# Station to Station Slackbot

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

**TODO**

```
/stations 230 W Superior St, Chicago

9 bikes, 11 docks at Franklin St & Chicago Ave
> Alternates:
> 2 bikes, 14 docks at Wells St & Huron St
> 2 bikes, 17 docks at Sedgwick St & Huron St
```

### Set your favorite locations by label

**TODO**

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
