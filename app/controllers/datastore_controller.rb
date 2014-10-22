class DatastoreController < ApplicationController

  def index
    @dir = params['dir'] || ''
    @files = hdfs.uls uid, @dir

    @files.each do |e|
      if e['type'] == 'DIRECTORY'
        length = 0
        concat = false
        (hdfs.uls uid, @dir, e['pathSuffix']).each do |se|
          if se['pathSuffix'].start_with? 'part-'
            concat = true
            length += se['length']
          end
        end
        if concat
          e['length'] = length
          e['type'] = 'FILE'
        end
      end
    end
  end


  def upload

  end


  def upload_do
    hdfs.ucreate uid, open(params['file'].tempfile), params['filename']
    render json: {success: true}
  end


  def delete
    params['filenames'].each do |filename|
      hdfs.udelete uid, filename
    end
    render json: {success: true}
  end


  def download
    f = hdfs.uread uid, params['dir'], params['filename']
    send_file f, filename: params['filename']
  end


  def view
    f = hdfs.uread uid, params['dir'], params['filename']
    send_file f, disposition: 'inline', type: 'text/plain'
  end

end
