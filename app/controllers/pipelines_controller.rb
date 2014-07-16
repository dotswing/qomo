class PipelinesController < ApplicationController

  layout 'pipelines'

  def index
    @pipelines = Pipeline.pub
  end


  def my
    @pipelines = Pipeline.belongs_to_user current_user
  end


  def new
    @pipeline = Pipeline.new
    render 'edit', layout: nil
  end


  def edit
    @pipeline = Pipeline.find params['id']
    render 'edit', layout: nil
  end


  def create
    pipeline = Pipeline.new params.require('pipeline').permit!
    pipeline.owner = current_user
    pipeline.save

    render text: true
  end


  def update
    Pipeline.find(params['id']).update(params.require('pipeline').permit!)

    redirect_to action: 'my'
  end


  def destroy
    Pipeline.delete params['id']
    redirect_to action: 'my'
  end

end
