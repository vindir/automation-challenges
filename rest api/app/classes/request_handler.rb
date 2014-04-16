require './app/classes/api_controller.rb'
require 'reel'

class RequestHandler < Reel::Server::HTTP
  def initialize(host = "127.0.0.1", port = 3000)
    Celluloid::Logger.info "Word Server listening on port #{port}"
    super(host, port, &method(:on_connection))
  end

  def on_connection(connection)
    connection.each_request do |request|
      APIController.route request
    end
  end
end
