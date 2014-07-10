require 'sinatra'

require_relative '../spec_helper'

class App < Sinatra::Base

  # Authentication
  #
  get '/auth/google' do
    redirect oauth.authorization_url
  end

  get '/auth/google/callback' do
    auth_code = request.env["rack.request.query_hash"]["code"]
    session['oauth.tokens'] = oauth.token_acquisition(auth_code)
    session['oauth.tokens']
  end

  get '/auth/google/refresh' do 

  end

  # Labels
  #
  get '/labels' do
    labels = Gmail::Labels.new(session['oauth.tokens']).list
    labels.map { |m| m.id }.join(", ")
  end

  get '/labels/:id' do
    label = Gmail::Labels.new(session['oauth.tokens']).get(params['id'])
    label.name
  end

  # Messages
  #
  get '/messages' do
    Gmail::Messages.new(session['oauth.tokens']).list.map{ |m| m }.join(' , ')
  end

  get '/messages/:id' do

  end


  private

    def oauth
      Gmail::OAuth.new({ 
        :client_id => ENV['GMAIL_AUTH_CLIENT_ID'], 
        :client_secret => ENV['GMAIL_AUTH_CLIENT_SECRET'] 
      })
    end

end