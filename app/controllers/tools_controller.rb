class ToolsController < ApplicationController
  def index
  end


  def box
    @tool = {
        id: SecureRandom.uuid,
        spec_id: 'awk',
        title: 'Awk',
        input: {id: 'input', label: 'Input', format: 'txt'},
        output: {id: 'output', label: 'Output', format: 'txt'},
        params: [
            {type: 'string', id: 'exp', label: 'Expression'}
        ]
    }

    render 'box', layout: nil
  end

end
