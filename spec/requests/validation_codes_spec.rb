require 'rails_helper'

RSpec.describe "ValidationCodes", type: :request do
  describe "sent validation_codes" do
    it "发送太频繁就会返回 429" do
      post '/api/v1/validation_codes', params: {email: 'huangdi_c@163.com'}
      expect(response).to have_http_status(200)
      post '/api/v1/validation_codes', params: {email: 'huangdi_c@163.com'}
      expect(response).to have_http_status(429)
    end
  end
end
