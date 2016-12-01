require 'sinatra'
require 'sinatra/cross_origin'
require 'sinatra/activerecord'
require './config/environments'
require './cors'
require './models/item'
require './models/message'
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
  cross_origin
  uri = URI("https://api.darksky.net/#{params['splat'][0]}")
  content_type 'application/json', :charset => 'utf-8'

  response = Net::HTTP.get uri
  response
end

post "/items" do
  cross_origin
  content_type 'application/json', :charset => 'utf-8'
  @item = Item.new(params[:item])
  if @item.save
    @item.to_json
  else
    { failure: true }.to_json
  end
end

get "/items" do
  cross_origin
  items = Item.all
  content_type 'application/json', :charset => 'utf-8'
  { items: items }.to_json
end

get "/items/:id" do
  cross_origin
  item = Item.find(params[:id])
  item.to_json
end

delete "/items/:id" do
  cross_origin
  content_type 'application/json', :charset => 'utf-8'
  item = Item.find(params[:id])
  item.destroy
  item.to_json
end

get "/messages" do
  if Message.all.length == 0
    Message.create(username: "Brian", text: "Off to a good start!")
  end
  cross_origin
  messages = Message.all
  content_type 'application/json', :charset => 'utf-8'
  { messages: messages }.to_json
end
