module Wiki::FilesHelper
  EXTENSION_ICONS = {
    '' => :unknown,
    '.pdf' => :acrobat,
    '.gif' => :paintbrush,
    '.jpg' => :paintbrush,
    '.jpeg' => :paintbrush,
    '.png' => :paintbrush,
    '.txt' => :text,
    '.doc' => :word,
    '.docx' => :word,
    '.ppt' => :powerpoint,
    '.pptx' => :powerpoint,
    '.zip' => :zip,
    '.xls' => :excel,
    '.xlsx' => :excel,
    '.ods' => :excel,
    '.rb' => :ruby,
    '.c' => :c,
    '.h' => :h,
    '.php' => :php,
    '.xml' => :xml,
    '.exe' => :exe
  }

  def extension_icon_tag(file)
    icon = EXTENSION_ICONS[file.extension.downcase] || EXTENSION_ICONS['']
    icon_tag("extensions/#{icon}")
  end

  def file_path(file, options = {})
    options.reverse_merge!({:controller => "/nodes", :action => :handle, :path => file.path})
    url_for(options)
  end
end
