# frozen_string_literal: true

module Googlepay
  class GiftCardObject

    EVENT_URL = 'https://www.googleapis.com/walletobjects/v1/giftCardObject?'

    def initialize(parameters)
      @parameters = parameters
    end

    def create
      rsa_private = OpenSSL::PKey::RSA.new Googlepay.configuration.service_account[:private_key]
      create_gift_card_object(@parameters)
      payload = {
          "iss": Googlepay.configuration.service_account[:client_email],
          "aud": 'google',
          "typ": 'savetoandroidpay',
          "iat":  Time.now.utc.to_i,
          "payload": {
              'giftCardObjects': [@parameters.dup.tap { |h| h.delete(:origin) }]
          },
          'origins': @parameters.fetch(:origin)
      }
      JWT.encode payload, rsa_private, 'RS256'
    end

  private

    def create_gift_card_object(gift_card)
      HTTParty.post("#{EVENT_URL}access_token=#{Googlepay.token}",
          :body => gift_card.to_json,
          :headers => { 'Content-Type' => 'application/json' } )
      end
    end
end