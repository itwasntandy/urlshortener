require 'sinatra'
require 'mysql2'
require './dbquery.rb'


begin
      approot = File.expand_path(File.dirname(__FILE__))
      rawconfig = File.read(approot + "/config.yml")
      config = YAML.load(rawconfig)
rescue
      raise "Could not load or parse configuration file, unable to continue"
end
if config.has_key?("database")
      dbquery = DBQuery.new(config["database"])
else
    raise "Could not find DB config in config file, unable to continue"
end

def add_shortcode(url,dbquery)
     # check if url already exists
       shortcode = dbquery.retrieve_shortcode(url)
       if (shortcode == nil)
         shortcode = rand(49**7).to_s(36)
         dbquery.insert_url(shortcode,url)
       end
       return shortcode
end


post '/s/' do
    url = params[:url]
    @shortcode = add_shortcode(url,dbquery)
    erb :short
end

get '/s/*' do 
    url = params[:splat][0]

    if (url == '')
        erb :default
    else 
      url.sub! 'http:/', 'http://'
      @shortcode = add_shortcode(url,dbquery)
      erb :short
    end
end

get '/l/:shortcode' do |shortcode|
    url = dbquery.retrieve_url(shortcode)
    if (url !=nil)
        redirect to(url)
    else
        return "No shortcode found"
    end
end

