class Tool < ActiveRecord::Base

  default_scope { order('created_at DESC') }

  enum status: {
      inactive: 0,
      active: 1
  }

  belongs_to :group, class_name: 'ToolGroup'

  serialize :params, JSON


  def files
    files = []
    Dir[File.join(Settings.home, self.dirname, 'bin', '*')].each do |k, v|

      return if File.directory? k
      files << {name: File.basename(k), size: File.size(k)}
    end

    files
  end

end
