class ToolGroup < ActiveRecord::Base
  default_scope { order('title DESC') }

  has_many :tools, foreign_key: 'group_id'
end
