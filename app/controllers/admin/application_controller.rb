class  Admin::ApplicationController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!

  before_action :require_admin

  private

  def require_admin
    unless current_user.admin?
      redirect_to status: 403
    end
  end

end
