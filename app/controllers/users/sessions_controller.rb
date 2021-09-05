# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]
    before_action :authenticate_user!
    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # def after_sign_in_path_for(resource)
    #   user_path(resource)
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    def guest_sign_in
      user = User.guest
      sign_in user
      redirect_to root_path, notice: 'ゲストユーザーとしてログインしました'
    end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
