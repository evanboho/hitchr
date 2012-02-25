module RidesHelper

  def compass_points(bearing)
    return "N" if 0 <= bearing && bearing <= 22.5 || 337.5 < bearing && bearing <= 360
    return "NE" if 22.5 < bearing && bearing <= 67.5
    return "E" if 67.5 < bearing && bearing <= 112.5
    return "SE" if 112.5 < bearing && bearing <= 157.5
    return "S" if 157.5 < bearing && bearing <= 202.5
    return "SW" if 202.5 < bearing && bearing <= 247.5
    return "W" if 247.5 < bearing && bearing <= 292.5
    return "NW" if 292.5 < bearing && bearing <= 337.5
  end
  
  def ridetime(ride)
    day = ride.datetime.strftime("%a")
    date = ride.datetime.strftime("%b %d")
    if ride.datetime.hour < 12
      hour = ride.datetime.hour.to_s + "am"
    else
      hour = (ride.datetime.hour - 12).to_s + "pm"
    end
    [day, date, hour]
  end

end