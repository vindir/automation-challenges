Rest Server
===========

## Considerations

There doesn't seem to be any subtext to this challenge.  Given that the solution presented is a plain ruby app which
will set up a web server and handle REST requests according to the API defined in the instructions.  The application
is simple, but written to show off basic OO methodology, robustness principles, and clean code organization.

### Additional Thoughts:
* For the PUT /word resource, including the word name in the request body is redundant to the resource identified in the URI
* A DELETE resource for the API isn't defined, but should be there. Implemented a target for DELETE.
* Need persistance, but no sense using the typical ORM in this use case.  Implemented using direct sqlite3
* It should use a web library like Reel that is lightweight, focuses on concurrency, and allows for clean code.
* For Code Review: Reel Response Codes are at https://github.com/tarcieri/http/blob/master/lib/http/response.rb
* Available time to knock this out is short, but missing unit tests is very poor form. Apologies.

## Pre-Requisites
There are a few pre-requisites which need to be in place to execute the web service we've built here.  They are listed
out in order of necessity, but instructions aren't detailed as it is quick to google better tutorials for any of them
than I could detail here.

* Install SQLite3, enabling the option SQLITE_ENABLE_COLUMN_METADATA (see www.sqlite.org/compile.html for details).
* Ruby (preferably using [RVM](http://rvm.io)) - This is tested with ruby2.1
* [Bundler](http://bundler.io/) for installing ruby dependencies.


## Let's Make it Run
So, the app developed here is quick_rest_server.rb, but first we need to use the bundler utility to prepare our gem
dependencies. Let's move into the rest-api challenge directory if we haven't and run bundler.

```
cd rest\ api
bundle install
```

With our dependencies in place, we can kick off the rest server to handle incoming requests.  The service is set to
run on port 3000 by default.

```
bundle exec ruby quick_rest_server.rb
```

With that done, we've got a web server running and handling REST requests!


## Put it to Work
There are three resources we can send REST requests to here. The curl examples outlined below can be used as examples
for adding and updating your own data to see the service in action. The database is pre-populated with some example
data, but using the below you can mix and match. Have fun!

### Creating/Updating Words
```
curl -i -H "Accept: application/json" -X PUT -d '{ "word": "bacteria" }' http://localhost:3000/word/bacteria
```

### Delete a Word
```
curl -i -H "Accept: application/json" -X DELETE http://localhost:3000/word/eukaryota
```

### Delete all Words
```
curl -i -H "Accept: application/json" -X DELETE http://localhost:3000/words
```

### Viewing Data
Using our curl examples we know how to send REST requests to the server, but we should probably be able to view it. To
get a look at the available data, use your browser of choice and visit [http://localhost:3000/words](http://localhost:3000/words)
to see a listing of all words and counts that have been sent through the API.  If you want to see data for a single word, just
point your browser at the word resource itself as in the example of [http://localhost:3000/words/eukaryota](http://localhost:3000/words/eukaryota)

