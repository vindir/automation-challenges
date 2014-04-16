

Considerations
--------------

Needs persistance, but no sense using the typical ORM in this use case.

Should use a web library like Reel that is lightweight, focuses on concurrency, and that highlights basic CS principles

Reel Response Codes: https://github.com/tarcieri/http/blob/master/lib/http/response.rb

For the PUT /word API, including the word name in the body is redundant to the resource identified in the URI
