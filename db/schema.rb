ActiveRecord::Schema.define(version: 20140413104534) do
  enable_extension 'uuid-ossp'

  create_table :tools, id: :uuid do |t|
    t.string :title, null: false
    t.string :contributor
    t.uuid :owner_id, index: true
    t.uuid :group_id, index: true
    t.text :command
    t.text :params
    t.text :usage

    t.integer :status, default: 0

    t.string :dirname

    t.timestamps
  end

  add_index :tools, [:title], unique: true


  create_table :tool_groups, id: :uuid do |t|
    t.string :title, null: false

    t.timestamps
  end

  add_index :tool_groups, [:title], unique: true


  create_table :pipelines, id: :uuid do |t|
    t.uuid :owner_id

    t.string :pid
    t.string :title
    t.text :desc

    t.text :boxes
    t.text :connections

    t.text :params

    t.boolean :public, default: false

    t.timestamps
  end


  create_table :users, id: :uuid do |t|
    t.string :username, null: false

    t.string :first_name
    t.string :last_name
    t.string :title
    t.string :organization
    t.string :location
    t.string :homepage
    t.boolean :admin, default: false
    t.boolean :guest, default: false

    ## Database authenticatable
    t.string :email,              null: false
    t.string :encrypted_password, null: false

    ## Recoverable
    t.string   :reset_password_token
    t.datetime :reset_password_sent_at

    ## Rememberable
    t.datetime :remember_created_at

    ## Trackable
    t.integer  :sign_in_count, default: 0, null: false
    t.datetime :current_sign_in_at
    t.datetime :last_sign_in_at
    t.string   :current_sign_in_ip
    t.string   :last_sign_in_ip

    ## Confirmable
    # t.string   :confirmation_token
    # t.datetime :confirmed_at
    # t.datetime :confirmation_sent_at
    # t.string   :unconfirmed_email # Only if using reconfirmable

    ## Lockable
    t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
    t.string   :unlock_token # Only if unlock strategy is :email or :both
    t.datetime :locked_at

    t.timestamps
  end

  add_index :users, :username, unique: true
  add_index :users, :email,                unique: true
  add_index :users, :reset_password_token, unique: true
  #add_index :users, :confirmation_token,   unique: true
  add_index :users, :unlock_token,         unique: true


  create_table :publications_users, id: false do |t|
    t.uuid :publication_id
    t.uuid :user_id
  end

  create_table :publications, id: :uuid do |t|
    t.string :pmid
    t.text :title
    t.text :authors
    t.text :journal
    t.date :published_at

  end


  create_table :file_meta do |t|
    t.string :path, null: false
    t.boolean :pub

  end

end
