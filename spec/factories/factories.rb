Factory.define :page do |p|
  p.title "My page"
end

Factory.define :file, :class => UploadedFile do |f|
  f.current_file_version_id 0
end

Factory.define :file_version do |f|

end

Factory.define :user do |u|

end