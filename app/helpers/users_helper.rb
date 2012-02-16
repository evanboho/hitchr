module UsersHelper

  def gravatar_for(user, options = { :size => 100 })
    user.email ||= "no email"
    gravatar_image_tag(user.email.downcase, :alt => h(user.firstname),
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
  
  
    
end
