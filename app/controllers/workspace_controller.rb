class WorkspaceController < ApplicationController

  def index
    @groups = ToolGroup.all
  end

end
