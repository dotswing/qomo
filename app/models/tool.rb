class Tool < ActiveRecord::Base

  MARKDOWN = Redcarpet::Markdown.new(Redcarpet::Render::HTML, extensions = {})

  default_scope { order('created_at DESC') }

  scope :belongs_to_user, ->(user) {where(owner: user)}

  enum status: {
      inactive: 0,
      active: 1
  }

  belongs_to :owner, class_name: 'User'
  belongs_to :group, class_name: 'ToolGroup'

  serialize :params, JSON


  def init(id = nil)
    id = SecureRandom.uuid unless id
    self.id = id
    self.dirname = "tmp-#{self.id}"
  end


  def inputs
    self.params.select {|k| k['type'].downcase == 'input'}
  end


  def output
    (self.params.select {|k| k['type'].downcase == 'output'})[0]
  end


  def normal_params
    self.params.reject {|k| %w(input output tmp).include? k['type'].downcase }
  end


  def dirpath_tmp
    File.join(Settings.home, "tmp-#{self.dirname}")
  end


  def dirpath
    File.join Settings.tools, self.dirname
  end


  def binpath
    File.join(dirpath, 'bin')
  end


  def files
    files = []
    Dir[File.join(binpath, '*')].each do |k, v|

      return if File.directory? k
      files << {name: File.basename(k), size: File.size(k)}
    end

    files
  end


  def usage_html
    MARKDOWN.render self.usage
  end

end
