require 'sinatra'
require 'net/http'

get "/" do
  "hello world"
end

get "/amway_events" do
  today = Date.today
  uri = URI::HTTP.build(
      :host => "www.amwaycenter.com",
      :path => "/events/calendar/#{today.year}/#{today.month}"
  )

  content_type 'application/json', :charset => 'utf-8'

  Net::HTTP.get(uri)
  # returns array of event objects {Title, StartDateTime, EndDateTime}
end
