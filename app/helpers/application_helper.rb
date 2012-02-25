module ApplicationHelper

  def full_title(page_title)
    base_title = "hitchr"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def logo
    logo = image_tag("hitchr1.png", :size => "250x69", :alt => "Sample", :class => "round")
  end
  
  def username(user)
    "#{user.firstname.humanize} #{user.lastname.to(0).humanize}"
  end

  def links
    # "link_to "Home", 'home'"
    # link = %w( home about contact help)
    # l = link.length
    # l.times do
    #  link_to link[l], link[l]
    #  puts link[l]
    #  l -= 1
    # end
  end
  
end