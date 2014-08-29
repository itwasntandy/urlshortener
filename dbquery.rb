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
        shortcode = dbclient.query("select shortcode from urls where url='#{url}' limit 1") rescue nil
        return shortcode.first['shortcode'] rescue nil
        #dbclient.last_id rescue nil

    end

    def retrieve_url(shortcode)
        url = dbclient.query("select url from urls where shortcode='#{shortcode}' limit 1") rescue nil
        return url.first['url'] rescue nil
    end
    def insert_url(shortcode,url)
        dbclient.query("insert into urls(url,shortcode) values('#{url}','#{shortcode}')") rescue nil
        dbclient.last_id rescue nil
    end
    def shortcode_use(shortcode)
        dbclient.query("insert into shortcodeusage(shortcode) values ('#{shortcode}')") rescue nil
    end
    def get_counters(shortcode)
        dbclient.query("select count(1) from shortcodeusage where shortcode='#{shortcode}'") rescue nil
    end

end

