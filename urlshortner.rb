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


get '/shorten' do
    if params.has_key?("url")
        url = params.fetch("url")
    else
        return "No URL sent to shortern"
    end



end

