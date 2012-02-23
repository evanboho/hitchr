module UsersHelper

  def gravatar_for(user, options = {})
    # user.email ||= "no email"
    options = { :size => 100 }.merge(options)
    options[:default] = "retro"
    gravatar_image_tag(user.email.downcase, 
                                :alt => h(user.firstname),
                                :class => 'gravatar',
                                :gravatar => options)
  end
  
  def distance_in_years(birthday)
    today = (Date.today.year * 365.25) + (Date.today.month * 30) + Date.today.day
    burfday = (birthday.year * 365.25) + (birthday.month * 30) + birthday.day
    days_old = (today - burfday)/365.25
    a = days_old.to_s.split('.')
    a.first
  end
  
  def age(dob)
    now = Time.now.utc.to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end
  
end
