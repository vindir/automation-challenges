Log Scraping
------------

## Considerations

This is the kind of question a system admin has to answer for themselves and others a dozen times a day, every day. To answer
questions like this, the simplest possible solution should be put to work. Given the need for speed, the answer provided here
is a bash script we'll use to parse out the requested data and print it out to screen with some basic formatting.

The bash script is the solution for this challenge, but it should be pointed out that in a production scenario we would put 
something like Logstash, Graylog2, or Splunk to work.  Log management and parsing tools like these bring us a simple-to-use,
pre-parsed database we can query for fast answers, add useful graphed output of our infrastructure, and open up the possibility
of teams without direct machine access the ability to find answers for themselves without bottlenecking.

## Putting it to Work
Running the bash script for parsing the given apache log is as easy as:

```
./log_scraper.sh
```

and will provide output in the form:
```
#========================================
Apache puppet_access_ssl.log Analysis

Status Code Counts:
    OK(200): 2377
    Non-OK: 6

Production sshd_config:
    Fetch Count: 6
    Non-OK Status Count: 0

dev/report Requests:
    PUT Requests: 9
    PUT Requests by IP:
        1 - 10.101.3.205
        1 - 10.114.199.41
        1 - 10.204.150.156
        1 - 10.204.211.99
        1 - 10.34.89.138
        1 - 10.39.111.203
        1 - 10.80.146.96
        1 - 10.80.174.42
        1 - 10.80.58.67
#========================================
```
