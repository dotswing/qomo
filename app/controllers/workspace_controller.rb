class WorkspaceController < ApplicationController

  def index
    @groups = ToolGroup.all
    @action = flash[:action]
    @pid = flash[:pid]
  end


  def load
    flash[:action] = 'load'
    flash[:pid] = params['id']
    redirect_to action: 'index'
  end


  def merge
    flash[:action] = 'merge'
    flash[:pid] = params['id']
    redirect_to action: 'index'
  end


end
