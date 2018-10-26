module ApplicationHelper
  def full_title(title)
    generic = "Ruby on Rails Tutorial Sample App"
    if title.empty?
      generic
    else
      title + " | " + generic
    end
  end

end
