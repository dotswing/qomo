class DatastoreController < ApplicationController


  def index
    @files = hdfs.ls uid
    pp @files
  end


  def upload

  end


  def upload_do
    hdfs.create open(params['file'].tempfile), uid, params['filename']
    render json: {success: true}
  end

end
