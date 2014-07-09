namespace :qomo do

  desc 'QOMO | Setup new deployed app'
  task setup: :environment do
    Rake::Task["db:schema:load"].invoke
  end

  desc "QOMO | Create default admin user"
  task create_admin_user: :environment do
    User.create username: Settings.root.username,
                email: Settings.root.email,
                admin: true,
                password: '11111111',
                password_confirmation: '11111111'
  end

end
