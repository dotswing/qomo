class Settings::SecurityController < Settings::ApplicationController

  def edit
    @user = current_user
    render layout: 'settings'
  end


  def update
    account_update_params = params.require(:user).permit!
    if account_update_params[:password].blank?
      account_update_params.delete 'password'
      account_update_params.delete 'password_confirmation'
    end

    @user = User.find(current_user.id)
    unless @user.valid_password? account_update_params['current_password']
      redirect_to action: 'edit'
      return
    end
    account_update_params.delete 'current_password'
    @user.update_attributes(account_update_params)

    sign_in @user, :bypass => true

    redirect_to action: 'edit'
  end

end
