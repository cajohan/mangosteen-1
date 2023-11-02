require 'rails_helper'

RSpec.describe "ValidationCodes", type: :request do
  describe "sent validation_codes" do
    it "可以发送" do
      post '/api/v1/validation_codes', params: {email: 'huangdi_c@163.com'}
      expect(response).to have_http_status(200)
    end
  end
end
