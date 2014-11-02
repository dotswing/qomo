class DatastoreController < ApplicationController

  def index
    @dir = params['dir'] || ''
    @dir = '' if @dir == '#'

    @files = hdfs.uls uid, @dir

    @files.each do |e|
      meta = FileMeta.find_by_path hdfs.ppath(uid, @dir, e['pathSuffix'])
      meta ||= FileMeta.new
      e['meta'] = meta
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

    respond_to do |format|
      format.html
      format.json do
        files_tree = @files.collect do |e|
          {
              text: e['pathSuffix'],
              id: @dir.blank? ? e['pathSuffix'] : File.join(@dir, e['pathSuffix']),
              children: e['type'] == 'DIRECTORY',
              icon: e['type'] == 'DIRECTORY' ? 'fa fa-folder' : 'fa fa-file-o'
          }
        end
        render json: files_tree
      end
    end

  end


  def public
    @files = []
  end


  def public_search
    username = params['username']
    filename = params['filename']
    filepath = params['filepath']

    @files = []

    if not username.blank?
      user = User.find_by_username username
      if user
        FileMeta.where('path like ? and pub=?', "#{user.id}/%", 'true').each do |e|
          f = hdfs.stat(File.join 'users', e.path)
          f['pathSuffix'] = e.path
          f['path'] = File.join 'public', e.path
          @files << f
        end
      end

    elsif not filename.blank?
      FileMeta.where('path like ? and pub=?', "%#{filename}%", 'true').each do |e|
        f = hdfs.stat(File.join 'users', e.path)
        f['pathSuffix'] = e.path
        f['path'] = File.join 'public', e.path
        @files << f
      end
    elsif not filepath.blank?
      username = filepath[1..filepath.index(':')-1]
      user = User.find_by_username username
      path = filepath[filepath.index(':')+1..-1]
      if user
        FileMeta.where('path=? and pub=?', "#{user.id}/#{path}", 'true').each do |e|
          f = hdfs.stat(File.join 'users', e.path)
          f['pathSuffix'] = e.path
          f['path'] = File.join 'public', e.path
          @files << f
        end
      end
    end

    render 'public'
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
    send_file downloadable_path, filename: params['filename']
  end


  def view
    send_file downloadable_path, disposition: 'inline', type: 'text/plain'
  end


  def mark_public
    fp = hdfs.ppath uid, params['dir'], params['filename']
    if params['mark'] == 'true'
      meta = FileMeta.find_or_create_by path: fp
      meta.pub = true
      meta.save
    else
      meta = FileMeta.find_by path: fp
      meta.pub = false
      meta.save
    end

    render json: {success: true}
  end


  protected

  def downloadable_path
    user_id = ''
    path = ''
    if params['path']
      path = params['path']
      if path.start_with? 'public'
        path = path[6..-1]
        user_id = path.split('/')[0]
        path = path.split('/')[1..-1].join('/')
      else
        user_id = uid
      end

    else
      user_id = uid
      path = File.join params['dir'], params['filename']
    end

    hdfs.uread user_id, path
  end

end
