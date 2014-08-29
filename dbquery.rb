require 'mysql2'
require 'yaml'

class DBQuery
    attr_accessor :dbclient
    def initialize(config)
     @dbclient =  Mysql2::Client.new(:host => config["host"],
                                     :username => config["user"],
                                     :password => config["passwd"],
                                     :database => config["dbname"]
                                    )
    end 
    def retrieve_shortcode(url)
        dbclient.query("select shortcode from urls where url=#{url}") rescue nil
    end
    def insert_url(shortcode,url)
        dbclient.query("insert into urls(shortcode,url) values('#{url}','#{shortcode}'") rescue nil
    end

end

