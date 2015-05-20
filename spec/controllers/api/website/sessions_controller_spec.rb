require 'rails_helper'

RSpec.describe Api::Website::SessionsController, type: :controller do
  include Devise::TestHelpers

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    allow(controller).to receive(:doorkeeper_token) {token}
  end

  describe 'POST #create' do
    it '/api/website/users/sign_in 能成功登录' do
      user = FactoryGirl.create(:user)
      post :create, user: {email: user.email, password: user.password}
      expect(response).to have_http_status(:success)
      expect(response.body).to eq({success: true, msg: 'login success'}.to_json)
      expect(subject.current_user).to eq(user)
    end

    it '/api/website/users/sign_in 不存在的用户不能登录' do
      post :create, user: {email: 'xxx@xxx.com', password: 'ffasdfadfasdf'}
      expect(response).to have_http_status(:success)
      expect(response.body).to eq({success: false, msg: 'login failed'}.to_json)
    end

    it '/api/website/users/sign_in 密码错误不能登录' do
      user = FactoryGirl.create(:user)
      post :create, user: {email: user.email, password: user.email + '1'}
      expect(response).to have_http_status(:success)
      expect(response.body).to eq({success: false, msg: 'login failed'}.to_json)
    end
  end

end
