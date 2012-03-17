module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def hilite(field, sort)
    if sort.to_s == field.to_s
      return :hilite
    else
      return nil
    end
  end  
end
