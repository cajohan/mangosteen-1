require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "获取账目" do
    it "分页(未登录)" do
      11.times {Item.create amount: 100}
      get '/api/v1/items'
      expect(response).to have_http_status(401)
    end
    it "分页" do
      user1 = User.create email: '1@qq.com'
      user2 = User.create email: '2@qq.com'
      11.times {Item.create amount: 100, user_id: user1.id}
      11.times {Item.create amount: 100, user_id: user2.id}

      # post '/api/v1/session', params: {email: user1.email, code: '231113'}
      # json = JSON.parse response.body
      # jwt = json['jwt']

      get '/api/v1/items', headers: user1.generate_auth_header
      expect(Item.count).to eq(22)
      # get '/api/v1/items', headers: {"Authorization": "Bearer #{jwt}"}
      get '/api/v1/items?page=1', headers: user1.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(10)
      # get '/api/v1/items?page=2', headers: {"Authorization": "Bearer #{jwt}"}
      get '/api/v1/items?page=2', headers: user1.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(1)
    end
    it "按时间筛选" do
      user1 = User.create email: '1@qq.com'
      item1 = Item.create amount: 100, created_at: '2018-01-02', user_id: user1.id
      item2 = Item.create amount: 100, created_at: '2018-01-02', user_id: user1.id
      item3 = Item.create amount: 100, created_at: '2019-01-01', user_id: user1.id
     
      get '/api/v1/items?created_after=2018-01-01&created_before=2018-01-03', headers: user1.generate_auth_header
      expect(response).to have_http_status 200
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq 2
      expect(json['resources'][0]['id']).to eq item1.id
    end
    it "按时间筛选(边界条件)" do
      # item1 = Item.create amount: 100, created_at: Time.new(2018,1,2) 时区问题
      # item1 = Item.create amount: 100, created_at: Time.new(2018,1,2,0,0,0,"+08:00")
      # item1 = Item.create amount: 100, created_at: Time.new(2018,1,2,0,0,0,"Z")
      user1 = User.create email: '1@qq.com'
      item1 = Item.create amount: 100, created_at: '2018-01-01', user_id: user1.id
      
      get '/api/v1/items?created_after=2018-01-01&created_before=2018-01-02', headers: user1.generate_auth_header
      expect(response).to have_http_status 200
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq 1
      expect(json['resources'][0]['id']).to eq item1.id
    end
    it "按时间筛选 2" do
      user1 = User.create email: '1@qq.com'
      item1 = Item.create amount: 100, created_at: '2018-01-01', user_id: user1.id
      item2 = Item.create amount: 100, created_at: '2017-01-01', user_id: user1.id
     
      get '/api/v1/items?created_after=2018-01-01', headers: user1.generate_auth_header
      expect(response).to have_http_status 200
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq 1
      expect(json['resources'][0]['id']).to eq item1.id
    end
    it "按时间筛选 3" do
      user1 = User.create email: '1@qq.com'
      item1 = Item.create amount: 100, created_at: '2018-01-01', user_id: user1.id
      item2 = Item.create amount: 100, created_at: '2019-01-01', user_id: user1.id

      get '/api/v1/items?created_before=2018-01-02', headers: user1.generate_auth_header
      expect(response).to have_http_status 200
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq 1
      expect(json['resources'][0]['id']).to eq item1.id
    end
  end
  describe "创建账目" do
    it '未登录创建' do 
      post '/api/v1/items', params: { amount: 100 }
      expect(response).to have_http_status 401
    end
    it "登录后创建" do 
      user = User.create email: '1@qq.com'
      expect {
        post '/api/v1/items', params: {amount: 99}, headers: user.generate_auth_header
      }.to change {Item.count}.by 1
      expect(response).to have_http_status 200
      json = JSON.parse response.body
      expect(json['resource']['id']).to be_an(Numeric)
      expect(json['resource']['amount']).to eq 99
      expect(json['resource']['user_id']).to eq user.id
    end
  end
end
