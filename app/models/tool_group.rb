class ToolGroup < ActiveRecord::Base
  has_many :tools, foreign_key: 'group_id'
end
