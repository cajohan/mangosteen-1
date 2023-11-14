require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "账目" do
  get "/api/v1/items" do
    # parameter :email, type: :string
    parameter :page, '页码'
    parameter :created_after, '创建时间起点'
    parameter :created_before, '创建时间终点'
    # response_field :id, 'ID', scope: :resources
    # response_field :amount, '金额（单位：分）', scope: :resources 可以缩写
    with_options :scope => :resources do
      response_field :id, 'ID'
      response_field :amount, '金额（单位：分）'
    end
    # header 'Content-type', "application/json"
    let(:created_after) {'2020-10-10'}
    let(:created_before) {'2020-11-11'}
    example "获取账目" do
      # 11.times do Item.create amount: 100, created_at: '2020-10-30' end
      user1 = User.create email: '1@qq.com'
      11.times do Item.create amount: 100, created_at: '2020-10-30', user_id: user1.id end

      jwt = ''
      no_doc do
        client.post 'api/v1/session', email:user1.email, code: '231113'
        json = JSON.parse response_body
        jwt = json['jwt']
      end
      header 'Authorization', "Bearer #{jwt}"
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      # expect(response_body).to eq ' '
      expect(json['resources'].size).to eq 10
    end
  end
end