class Admin::UsersController < Admin::ApplicationController

  def index
    @users = User.all
  end


  def admin
    user = User.find params['id']
    if params['admin'] == 'true'
      user.admin = true
    else
      user.admin = false
    end
    user.save

    render json: {success: true}
  end

end
