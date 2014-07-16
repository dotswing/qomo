class WorkspaceController < ApplicationController

  def index
    @groups = ToolGroup.all
  end


  def load
    @groups = ToolGroup.all
    @pipeline = Pipeline.find params['id']
    render 'index'
  end


  def merge
    @groups = ToolGroup.all
    @pipeline = Pipeline.find params['id']
    render 'index'
  end


end
