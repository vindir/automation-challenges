# encoding: utf-8
require 'json'
require './app/models/words.rb'

class APIController
  attr_accessor :request

  NotFound = Class.new StandardError
  InvalidRequest = Class.new StandardError

  METHODS = {
    'GET' =>  %w{ words },
    'POST' => %w{ },
    'PUT' =>  %w{ word },
    'DELETE' =>  %w{ words word }
  }.freeze

  def self.route(request)
    new.route(request)
  end

  def route(request)
    @request = request
    _, action, resource = @request.url.split '/'

    Celluloid::Logger.info "Handling #{request.method.upcase} request for action #{action.inspect} with resource #{resource.inspect}"

    raise InvalidRequest, "Invalid action requested"  unless METHODS[@request.method].include? action
    send "#{@request.method.downcase}_#{action}", resource
  rescue NotFound => e
    respond_with_error :not_found, e.message
  rescue InvalidRequest => e
    respond_with_error :bad_request, e.message
  rescue => e
    respond_with_error :internal_server_error, e.message
    raise
  end

private

  def put_word(resource)
    data = parse_request_body
    raise InvalidRequest, "Word field missing" if data['word'].nil?
    raise InvalidRequest, "Word field missing" if data['word'].empty?
    raise InvalidRequest, "PUT requests must be one word in length" unless single_word? data['word']
    raise InvalidRequest, "Resource id and word value do not match" unless data['word'] == resource

    add_word data['word']
    respond_with_json :ok, { resource => count_for(resource) }
  end
 
  def get_words(resource)
    if resource
      respond_with_json :ok, { resource => count_for(resource) }
    else
      respond_with_json :ok, all_words
    end
  end

  def delete_word(resource)
    resource_count = count_for resource
    raise InvalidRequest, "Resource does not exist" unless resource_count.nonzero?

    remove_word resource
    respond_with_json :ok, { resource => count_for(resource) }
  end
 
  def delete_words(resource)
    delete_all_words
    respond_with_json :ok, all_words
  end
 
  def respond_with_error(code, message)
    headers = {
      "Content-Type" => "application/json"
    }
    body = {error: message}.to_json
    @request.respond code, headers, body
  end

  def respond_with_json(code, data)
    headers = {
      "Content-Type" => "application/json"
    }
    body = data.to_json
    @request.respond code, headers, body
  end

  def parse_request_body
    JSON.parse(@request.body.to_s)
  end

  def single_word?(word)
    word.split.size == 1
  end

  def add_word(resource)
    Words.add_word resource
  end

  def remove_word(resource)
    Words.delete_word resource
  end

  def count_for(resource)
    Words.count_for resource
  end

  def all_words
    Words.all_words
  end

  def delete_all_words
    Words.delete_all_words
  end
end
