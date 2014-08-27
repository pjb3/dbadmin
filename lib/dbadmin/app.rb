require 'sinatra'

module DBAdmin
  class App < Sinatra::Base

    enable :sessions
    set :session_secret, "It's a secret to everyone"

    def db
      @db ||= Sequel.connect(ENV['DATABASE_URL'])
    end

    helpers do
      def tables
        @tables ||= db.tables.sort
      end
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
        if params[:filter].present?
          @filter = params[:filter]
          ds = ds.where(@filter)
        end
        @result_orientation = params[:result_orientation] == 'grid' ? 'grid' : 'list'
        @columns = ds.columns
        @rows = ds.limit(@limit, @offset).all
        erb :tables
      else
        session[:last_table] = nil
        redirect "/tables"
      end
    end

    get "/queries" do
      @sql = session[:sql]
      erb :query
    end

    post "/queries" do
      if @sql = params[:sql]
        session[:sql] = @sql
        @limit = params[:limit].to_i
        @limit = 50 unless @limit > 0
        @offset = params[:offset].to_i
        @rows = db[@sql].limit(@limit).all
        @columns = db[@sql].columns
        @result_orientation = params[:result_orientation] == 'grid' ? 'grid' : 'list'
      end
      erb :query
    end
  end
end
