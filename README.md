# MultiApi

`MultiApi` is a basic web app that receives an array of urls posted to `/` and
returns a array representing a get request to each url like so:

```
# request
["http://example.com/url1","http://example.com/url2"]

# response
[
  {
    "url":"http://example.com/url1",
    "response": "first response"
  },
  {
    "url":"http://example.com/url2",
    "response": "second response"
  }
]
```

It gets hits the passed urls simultaneously so it is meant to be a fast way to
aggregate responses from multiple endpoints.

## Running it

1. `mix deps.get`
2. `mix run --no-halt`
