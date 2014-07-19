class Admin::ToolGroupsController <  Admin::ApplicationController

  def index
    @groups = ToolGroup.all
  end

  def create
    ToolGroup.create title: params['title']
    redirect_to action: 'index'
  end


  def edit
    @group = ToolGroup.find params['id']
    render layout: nil
  end


  def update
    @group = ToolGroup.find params['id']
    @group.update params.require('tool_group').permit!
    redirect_to action: 'index'
  end


  def destroy
    group = ToolGroup.find params['id']

    if group.tools.length == 0
      ToolGroup.delete params['id']
    end

    redirect_to action: 'index'
  end
end
