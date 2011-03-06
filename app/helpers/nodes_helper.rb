module NodesHelper
  def markdown(text)
    text.blank? ? '' : Kramdown::Document.new(text, :auto_ids => false).to_html.html_safe
    #Maruku.new(text).to_html.html_safe
  end

end
