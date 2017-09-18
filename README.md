# TIY Proxy Server

This is a little Sinatra app that I used at The Iron Yard as a teaching tool, to get around CORS issues so we could use certain interesting APIs in class, and to help front-end students who ran into CORS issues in their own projects. 

The original use case was to show what routing looks like from the perspective of server code. It was also a convenient way to illustrate how JSON and JSONP responses can be created, and to show the back end of a RESTful API. In order to show the API at work, I needed to persist data. The easiest solution was to import ActiveRecord. Using a 345kb gem to enable me to write about ten lines of code is swatting a gnat with a howitzer, but it got the job done.

I also wound up using this to get around CORS issues in a personal project, https://github.com/bgates/tiy-orl-calendar.
