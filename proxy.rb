require 'sinatra'
require 'sinatra/cross_origin'
require 'net/http'

configure do
  set :allow_origin, :any
  set :allow_methods, [ :get, :options ]
  enable :cross_origin
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
end

get "/" do
  "hello world"
end

get "/amway_events/:year/:month" do

  uri = URI::HTTP.build(
      :host => "www.amwaycenter.com",
      :path => "/events/calendar/#{params[:year]}/#{params[:month]}"
  )

  content_type 'application/json', :charset => 'utf-8'

  Net::HTTP.get(uri)
  # returns array of event objects {Title, StartDateTime, EndDateTime}
end
