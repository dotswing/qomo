class Tool < ActiveRecord::Base

  default_scope { order('created_at DESC') }

  enum status: {
      inactive: 0,
      active: 1
  }

  belongs_to :owner, class_name: 'User'
  belongs_to :group, class_name: 'ToolGroup'

  serialize :params, JSON


  def initdir
    self.dirname = "tmp-" + SecureRandom.uuid
  end


  def inputs
    self.params.select {|k| k['type'].downcase == 'input'}
  end


  def output
    (self.params.select {|k| k['type'].downcase == 'output'})[0]
  end


  def normal_params
    self.params.reject {|k| ['input', 'output'].include? k['type'].downcase }
  end


  def files
    files = []
    Dir[File.join(Settings.home, self.dirname, 'bin', '*')].each do |k, v|

      return if File.directory? k
      files << {name: File.basename(k), size: File.size(k)}
    end

    files
  end

end
