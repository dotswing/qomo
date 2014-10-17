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


  def delete
    params['filenames'].each do |filename|
      hdfs.delete uid, filename
    end
    render json: {success: true}
  end


  def download
    f = hdfs.read uid, params['filename']
    send_file f, filename: params['filename']
  end


  def view
    f = hdfs.read uid, params['filename']
    send_file f, disposition: 'inline', type: 'text/plain'
  end

end
