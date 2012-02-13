Factory.define :user do |user|
  user.name                  "Example Name"
  user.email                 "example@example.com"
  user.nickname              "screenname"
  user.password              "foobar"
  user.password_confirmation "foobar"
end