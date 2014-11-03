class Settings::ProfilesController < Settings::ApplicationController

  def edit
    @user = current_user
    render layout: 'settings'
  end


  def update
    current_user.update params.require(:user).permit!
    redirect_to action: 'edit'
  end


end
