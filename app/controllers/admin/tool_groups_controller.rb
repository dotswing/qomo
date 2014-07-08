class Admin::ToolGroupsController <  Admin::ApplicationController

  def index
    @groups = ToolGroup.all
  end

  def create
    ToolGroup.create title: params['title']
    redirect_to action: 'index'
  end

  def destroy
    ToolGroup.delete params['id']
    redirect_to action: 'index'
  end
end
