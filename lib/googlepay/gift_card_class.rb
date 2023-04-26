# frozen_string_literal: true

module Googlepay
  class GiftCardClass

    EVENT_URL = 'https://www.googleapis.com/walletobjects/v1/giftCardClass'

    def initialize(parameters)
      @parameters = parameters
    end

    def create
      result = HTTParty.post("#{EVENT_URL}?access_token=#{Googlepay.token}",
                               :body => @parameters.to_json,
                               :headers => { 'Content-Type' => 'application/json' } )
      return result if result['error'].nil?
      update if result['error']['code'] == 409
    end

    def update
      HTTParty.put("#{EVENT_URL}/#{@parameters[:id]}?access_token=#{Googlepay.token}",
                   :body => @parameters.to_json,
                   :headers => { 'Content-Type' => 'application/json' } )
    end
  end
end