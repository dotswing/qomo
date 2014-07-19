class Admin::ToolsController <  Admin::ApplicationController

  def index
    @tools = Tool.all
  end


  def new
    @tool = Tool.new
    @tool.init
    @groups = ToolGroup.all
  end


  def create
    tool = Tool.new params.require(:tool).permit!
    tool.dirname = tool.id
    tool.owner = current_user
    tool.active!
    tool.save

    if File.exist? tool.dirpath_tmp
      FileUtils.mv tool.dirpath_tmp, tool.dirpath
    end

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


  def uploadfile
    tool = Tool.find_by_id params['id']
    unless tool
      tool = Tool.new
      tool.init params['id']
      FileUtils.mkdir_p tool.binpath
    end
    FileUtils.cp params['file'].tempfile, File.join(tool.binpath, params['filename'])

    render json: {success: true}
  end


  def deletefile
    tool = Tool.find_by_id params['id']
    unless tool
      tool = Tool.new
      tool.init params['id']
    end
    FileUtils.rm File.join(tool.binpath, params['filename'])
    render json: {success: true}
  end

end
