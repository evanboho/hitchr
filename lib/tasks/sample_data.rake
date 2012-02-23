namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:firstname => "Example",
    			 :lastname => "User",
                 :email => "example@railstutorial.org",
               # :nickname => "example user",
                 :password => "foobar",
                 :password_confirmation => "foobar")
    99.times do |n|
      firstname  = Faker::Name.firstname
      email = "example-#{n+1}@railstutorial.org"
    # nickname "example-#{n+1}"
      password  = "password"
      User.create!(:firstname => firstname,
                   :lastname => lastname,
                   :email => email,
                 # :nickname => nickname,
                   :password => password,
                   :password_confirmation => password)
    end
  end
end