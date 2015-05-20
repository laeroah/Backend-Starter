require 'rails_helper'

describe 'routing to api center controller' do
  it 'rotues /api/website/users/sign_in to api/website/sessions#create' do
    expect(post: '/api/website/users/sign_in').to route_to(
      controller: 'api/website/sessions',
      action: 'create',
      format: 'json'
    )
  end
end
