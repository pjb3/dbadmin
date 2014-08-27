require 'active_support/core_ext'
require 'optparse'
require 'sequel'
require 'yaml'

require 'dbadmin/app'

module DBAdmin

  VERSION = "0.2.0"

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
    ENV['DATABASE_URL'] = url if url

    puts "Starting DB Admin #{VERSION} at http://#{options[:Host]}:#{options[:Port]}"
    Rack::Server.start(options.merge(app: DBAdmin::App))
  end

end
