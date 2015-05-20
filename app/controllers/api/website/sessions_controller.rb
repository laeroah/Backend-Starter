class Api::Website::SessionsController < Devise::SessionsController
  respond_to :json

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    yield resource if block_given?
    render json: {success: true, msg: 'login success'}
  end

  def failure
    render json: {success: false, msg: 'login failed'}
  end

  protected
  def auth_options
    { scope: resource_name, recall: "#{controller_path}#failure" }
  end

end