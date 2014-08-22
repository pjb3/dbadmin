require 'active_support/core_ext'
require 'optparse'
require 'sequel'
require 'sinatra'
require 'yaml'

class Symbol
  alias to_liquid to_s
end

class DBAdmin < Sinatra::Base
  enable :sessions
  set :session_secret, "It's a secret to everyone"

  class << self
    attr_accessor :db

    def connect(url)
      @db = Sequel.connect(url)
    end
  end

  def db
    self.class.db
  end

  def self.start(argv)
    options = {
      :Host => "localhost",
      :Port => 8888,
      :daemonize => true
    }
    parser = OptionParser.new do |o|
      o.on "-p", "--port PORT", "The port to run the web server on" do |arg|
        options[:Port] = arg.to_i
      end

      o.on "-h", "--host HOST", "The host to run the web server on" do |arg|
        options[:Host] = arg
      end

      o.on "-f", "--foreground", "Run server in the foreground" do |arg|
        options[:daemonize] = arg ? false : true
      end

      o.banner = "Usage: dbadmin [options] [db_url]\n\nExample: dbadmin -p 8080 mysql://user:pass@host/db\n\n"

      o.on_tail "--help", "Show help" do
        puts o
        exit 1
      end
    end
    url = parser.parse(argv).first
    if url
      connect(url)
      puts "DB Admin now running at http://#{options[:Host]}:#{options[:Port]}"
    else
      puts parser
      exit 1
    end
    Rack::Server.start(options.merge(app: self))
  end

  get "/" do
    redirect "/tables"
  end

  get "/tables" do
    table = session[:last_table] || db.tables.first
    redirect "/tables/#{table}/content"
  end

  get "/tables/:table_name/content" do
    @table = session[:last_table] = params[:table_name].to_sym
    if db.table_exists?(@table)
      @limit = params[:limit].to_i
      @limit = 50 unless @limit > 0
      @offset = params[:offset].to_i
      ds = db[@table]
      @tables = db.tables
      @columns = ds.columns
      @rows = ds.limit(@limit, @offset).all
      erb :tables
    else
      session[:last_table] = nil
      redirect "/tables"
    end
  end

  get "/query" do
    @sql = session[:sql]
    erb :query
  end

  post "/query" do
    if @sql = params[:sql]
      session[:sql] = @sql
      @limit = params[:limit].to_i
      @limit = 50 unless @limit > 0
      @offset = params[:offset].to_i
      @rows = db[@sql].all
      @columns = db[@sql].columns
    end
    erb :query
  end

end
