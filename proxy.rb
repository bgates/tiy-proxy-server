require 'sinatra'
require 'sinatra/cross_origin'
require './cors'
require 'net/http'

get "/" do
  "hello world"
end

get "/amway_events/:year/:month" do
  cross_origin
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

get "/json_padding_demo" do
  content_type 'application/javascript', :charset => 'utf-8'

  "console.log('here comes the demo...');
  #{params['callback']}({ \"data\": { \"month\": \"August\",
                                      \"day\": 23,
                                      \"year\": 1974 } })"
end

get "/darksky/*" do
  cross_origin
  uri = URI::HTTP.build(
      :host => "api.darksky.net",
      :path => params["splat"],
      :port => 443
  )

  content_type 'application/json', :charset => 'utf-8'

  response = Net::HTTP.get(uri)
end
