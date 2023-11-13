require 'rails_helper'

RSpec.describe "ValidationCodes", type: :request do
  describe "会话" do
    it "登录（创建会话）" do
      User.create email: 'junhuangc@foxmail.com'
      post '/api/v1/session', params: {email: 'junhuangc@foxmail.com',code:"231113"}
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json['jwt']).to be_a(String)
    end
  end
end
