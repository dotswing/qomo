class ToolsController < ApplicationController
  def index
  end


  def box
    @tool = Tool.find params['id']

    render 'box', layout: nil
  end

end
