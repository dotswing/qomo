class PipelinesController < ApplicationController

  layout 'pipelines'

  def index
    @pipelines = Pipeline.pub
  end


  def my
    @pipelines = Pipeline.belongs_to_user current_user
  end


  def show
    @pipeline = Pipeline.find params['id']
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pipeline}
    end
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


  def mark_public
    pipeline = Pipeline.find params['id']
    pipeline.public = (params['public'] == 'true')
    pipeline.save
    render json: {success: true}
  end

end
