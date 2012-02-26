module ApplicationHelper

  def full_title(page_title)
    base_title = "hitchr"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  # def full_title(subtitle)
  #   sub_title.blank? ? "hitchr" : "hitcher - #{subtitle}"
  # end
  
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
  
  def state_select(form, attribute)
    state_list = ['AL',
  					'AK',
  					'AZ',
  					'AR',
  					'CA',
  					'CO',
  					'CT',
  					'DE',
  					'FL',
  					'GA',
  					'HI',
  					'ID',
  					'IL',
  					'IN',
  					'IA',
  					'KS',
  					'KY',
  					'LA',
  					'ME',
  					'MD',
  					'MA',
  					'MI',
  					'MN',
  					'MS',
  					'MO',
  					'MT',
  					'NE',
  					'NV',
  					'NH',
  					'NJ',
  					'NM',
  					'NY',
  					'NC',
  					'ND',
  					'OH',
  					'OK',
  					'OR',
  					'PA',
  					'RI',
  					'SC',
  					'SD',
  					'TN',
  					'TX',
  					'UT',
  					'VT',
  					'VA',
  					'WA',
  					'WV',
  					'WI',
  					'WY']

  	form.select(attribute, state_list, {}, {class: "chzn-select", style:"width:60px"})
  end
  
end