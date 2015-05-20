class Api::MobileController < ApplicationController

  # skip parent filter
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  before_action :validate_user_token!

  helper_method :current_user, :user_signed_in?

  private
  def validate_user_token!
    @_user = User.serialize_from_cookie params[:id], params[:token]
    if @_user.nil?
      render json: {status: 100, msg: 'need login first.'}
    end
  end

  def current_user
    @_user
  end

  def user_signed_in?
    @_user.present?
  end

end
