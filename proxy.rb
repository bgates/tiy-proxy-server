require 'sinatra'
require 'sinatra-cross_origin'
require 'net/http'

configure do
  enable :cross_origin
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
