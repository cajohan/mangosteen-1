require 'rails_helper'
require 'active_support/testing/time_helpers'

RSpec.describe "Me", type: :request do
  include ActiveSupport::Testing::TimeHelpers
  describe "获取当前用户" do
    it "登录后成功获取" do
      expect {
        post '/api/v1/session', params: {email: 'junhuangc@foxmail.com', code: '123456'}
      }.to change { User.count }.by +1
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      jwt = json['jwt']
      get '/api/v1/me', headers: {'Authorization': "Bearer #{jwt}"}
      expect(response).to have_http_status(200)
      json = JSON.parse response.body
      expect(json['resource']['id']).to be_a Numeric
    end
    it "jwt过期 但可以refresh" do
      travel_to Time.now - 3.hours
      user1 = create :user
      jwt = user1.generate_jwt
      refresh_token = user1.generate_refresh_token

      travel_back
      get '/api/v1/me', headers: {'Authorization': "Bearer #{jwt} #{refresh_token}"}
      json = JSON.parse response.body
      expect(response).to have_http_status(200)
      new_jwt = json['jwt']
      get '/api/v1/items', headers: {'Authorization': "Bearer #{new_jwt} #{refresh_token}"}
      expect(response).to have_http_status(200)
    end
    it "jwt过期 且超过7天" do
      travel_to Time.now - 8.days
      user1 = create :user
      jwt = user1.generate_jwt
      refresh_token = user1.generate_refresh_token

      travel_back
      get '/api/v1/me', headers: {'Authorization': "Bearer #{jwt} #{refresh_token}"}
      json = JSON.parse response.body
      expect(response).to have_http_status(401)
    end
    it "jwt没过期" do
      travel_to Time.now - 1.hours
      user1 = create :user
      jwt = user1.generate_jwt

      travel_back
      get '/api/v1/me', headers: {'Authorization': "Bearer #{jwt}"}
      expect(response).to have_http_status(200)
    end
  end
end
