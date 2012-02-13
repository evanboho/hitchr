module UsersHelper

  def gravatar_for(user, options = { :size => 100 })
    user.email ||= "no email"
    gravatar_image_tag(user.email.downcase, :alt => h(user.name),
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
  
  def username(user)
    if user.name.blank?
      user.name = "no name"
    end
  end
    
end
