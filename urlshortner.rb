require 'sinatra'
require 'mysql2'
require './dbquery.rb'
require 'zlib'


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
         shortcode = Zlib::crc32(url)
         dbquery.insert_url(shortcode,url)
       end
       return shortcode
end


post '/s/' do
    url = params[:url]
    @shortcode = add_shortcode(url,dbquery)
    erb :short
    #return response
end

get '/s/*' do 
    #url = params[:captures]
    #protocol = params[:splat].first
    #puts protocol
    #address = params[:splat][1..-1].join('/')
    #puts address
    url = params[:splat][0]

    if (url == '')
        erb :default
    else 
      url.sub! 'http:/', 'http://'
    # check if url already exists
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

