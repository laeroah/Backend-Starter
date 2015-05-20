class Api::SessionsController < Api::ApiController
  skip_before_action :validate_user_token!, only: :create

  def create
    @user = User.find_by(email: params[:email])
    if @user.present? && @user.valid_password?(params[:password])
      @user.remember_me!
      user_info = User.serialize_into_cookie(@user)
      render json: {status: 0, id: @user.id, token: user_info.last}
    else
      render json: {status: 1, msg: 'Email or Password error.'}
    end
  end

  def destroy
    @user.forget_me!
  end
end