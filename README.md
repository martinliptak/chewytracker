# README #

ChewyTracker keeps track of your calories. It is a sample application to try out new things. 

## API


```
#!ruby

require "faraday"
require "json"

conn = Faraday.new(url: "http://chewytracker.herokuapp.com/")

# authenticate
resp = conn.post "/api/v1/access_tokens/", credentials: { email: "...", password: "..." }
body = JSON.parse(resp.body)
token = body["name"]
user_id = body["user_id"]

# list meals
resp = conn.get "/api/v1/meals/", token: token
meals = JSON.parse(resp.body)
```

## Setup

Requirements: 
- PostgreSQL

```
#!sh
# install gems
bundle install

# prepare database
rake db:create
rake db:migrate
rake db:seed

# run tests
rake test

# run server
rails s
```

## License

The MIT License (MIT)

Copyright (c) 2015 Martin Lipták

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
