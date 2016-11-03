require 'sinatra'
require 'sinatra/cross_origin'
require './cors'
require 'net/http'

get "/" do
  "hello world"
end

get "/amway_events/:year/:month" do
  uri = URI::HTTP.build(
      :host => "www.amwaycenter.com",
      :path => "/events/calendar/#{params[:year]}/#{params[:month]}"
  )

  content_type 'application/json', :charset => 'utf-8'

  response = Net::HTTP.get(uri)
  logger.info "HEADERS IS #{headers}"
  response
  # returns array of event objects {Title, StartDateTime, EndDateTime}
end
