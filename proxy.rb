require 'sinatra'
require 'sinatra/cross_origin'
require 'sinatra/activerecord'
require './config/environments'
require './cors'
require './models/item'
require './models/message'
require 'net/http'

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
