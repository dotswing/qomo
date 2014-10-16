class ApplicationController < ActionController::Base

  include Qomo::HDFS

  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :prepare_hdfs


  def uid
    current_user.id
  end


  def engine
    Jimson::Client.new Settings.engine.url
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
  end


  def prepare_hdfs
    if user_signed_in?
      hdfs.mkdir(current_user.id)
    end
  end

end
