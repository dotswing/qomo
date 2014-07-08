class Pipeline < ActiveRecord::Base
  belongs_to :owner, class: 'User'

  enum status: {
      private: 0,
      public: 1
  }

end
