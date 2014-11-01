class HomeController < ApplicationController

  def index
    redirect_to  workspace_index_path
  end

end
