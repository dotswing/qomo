class Tool < ActiveRecord::Base

  default_scope { order('created_at DESC') }

  enum status: {
      inactived: 0,
      actived: 1
  }

  belongs_to :group, class_name: 'ToolGroup'

  serialize :params, JSON
end
