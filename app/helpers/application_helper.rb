module ApplicationHelper
  def icon_tag(source, options = {})
    options = options.reverse_merge!({:alt => '', :size => '16x16'})
    image_tag("icons/#{source}.png", options)
  end
end
