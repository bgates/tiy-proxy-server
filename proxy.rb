require 'sinatra'
require 'sinatra/cross_origin'
require 'sinatra/activerecord'
require './config/environments'
require './cors'
require './models/item'
require './models/message'
require 'net/http'
# start with bundle exec rackup -p 4567
def allow_json
  cross_origin
  content_type 'application/json', :charset => 'utf-8'
end

get "/" do
  "hello world"
end

get "/amway_events/:year/:month" do
  allow_json
  uri = URI::HTTP.build(
      :host => "www.amwaycenter.com",
      :path => "/events/calendar/#{params[:year]}/#{params[:month]}"
  )


  response = Net::HTTP.get(uri)
  response
  # returns array of event objects {Title, StartDateTime, EndDateTime}
end

get "/json_padding_demo" do
  content_type 'application/javascript', :charset => 'utf-8'

  "#{params['callback']}({ \"data\": { \"month\": \"August\",
                                      \"day\": 23,
                                      \"year\": 1974 } })"
end

get "/darksky/*" do
  allow_json
  uri = URI("https://api.darksky.net/#{params['splat'][0]}")

  response = Net::HTTP.get uri
  response
end

get "/trivia" do
  allow_json
  uri = URI("http://trivia.propernerd.com/api/questions?#{request.query_string}")
  puts uri.inspect

  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri)
  puts request.inspect

  user  = '2298623c5e504c94828de0519d5ae973e8289f36'
  password  = '504ffbd0aa78df6107f428078dfbc1f976ae026b'
  request.basic_auth user, password

  #response = Net::HTTP.start(uri.hostname, uri.port) do |http|
    response = http.request(request)
  #end
  puts response.inspect
  response.body
end

get "/disney/*" do
  allow_json
  uri = URI("http://touringplans.com/#{params['splat'][0]}")

  response = Net::HTTP.get uri
  response
end

post "/items" do
  allow_json
  @item = Item.new(params[:item])
  if @item.save
    @item.to_json
  else
    { failure: true }.to_json
  end
end

get "/items" do
  allow_json
  items = Item.all
  { items: items }.to_json
end

get "/items/:id" do
  allow_json
  item = Item.find(params[:id])
  item.to_json
end

delete "/items/:id" do
  allow_json
  item = Item.find(params[:id])
  item.destroy
  item.to_json
end

get "/messages" do
  allow_json
  messages = Message.all
  { messages: messages }.to_json
end

post "/messages" do
  allow_json
  message = Message.create(params[:message])
  { message: message }.to_json
end

delete "/messages/:id" do
  allow_json
  message = Message.find(params[:id])
  message.destroy
  { message: message }.to_json
end
