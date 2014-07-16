class ToolsController < ApplicationController

  layout 'tools'

  def index
    @tools = Tool.active
  end


  def my
    @tools = Tool.belongs_to_user current_user
  end


  def box
    tool = Tool.find params['id']

    if params['bid']
      id = params['bid']
    else
      id = SecureRandom.uuid
    end

    @boxes = [{id: id, tool: tool}]

    render 'boxes', layout: nil
  end


  def boxes
    @boxes = params.require('box').map do |e|
      id = e['id']
      unless e['id']
        id = SecureRandom.uuid
      end
      tool = Tool.find e['tid']
      {id: e['id'], tool: tool}
    end

    render 'boxes', layout: nil
  end



  def new
    @tool = Tool.new
    @tool.initdir
    @groups = ToolGroup.all
  end


  def edit
    @tool = Tool.find params['id']
    @groups = ToolGroup.all
    render 'new'
  end


  def create
    tool = Tool.new params.require(:tool).permit!
    tool.id = SecureRandom.uuid
    tool.dirname = tool.id
    tool.owner = current_user
    tool.inactive!
    tool.save
    redirect_to action: 'edit', id: tool.id
  end


  def update
    tool = Tool.find params['id']
    tool.update params.require(:tool).permit!
    redirect_to action: 'edit', id: tool.id
  end


  def show
    @tool = Tool.find params['id']
  end

end
