class Admin::ToolsController <  Admin::ApplicationController

  def index
    @tools = Tool.all
  end


  def new
    @tool = Tool.new
    @tool.initdir
    @groups = ToolGroup.all
  end


  def create
    tool = Tool.new params.require(:tool).permit!
    tool.id = SecureRandom.uuid
    tool.dirname = tool.id
    tool.save
    redirect_to action: 'edit', id: tool.id
  end


  def edit
    @tool = Tool.find params['id']
    @groups = ToolGroup.all
    render 'new'
  end


  def update
    tool = Tool.find params['id']
    tool.update params.require(:tool).permit!
    redirect_to action: 'edit', id: tool.id
  end


  def destroy
    Tool.delete params['id']
    redirect_to action: 'index'
  end


  def delete
    Tool.delete params['ids']
    redirect_to action: 'index'
  end

end
