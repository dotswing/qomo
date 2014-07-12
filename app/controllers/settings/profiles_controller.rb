class Settings::ProfilesController < Settings::ApplicationController

  layout 'settings'

  def edit
    @user = current_user
  end


  def update
    current_user.update params.require(:user).permit!
    redirect_to action: 'edit'
  end


end
