Factory.sequence :username do |n|
  "user#{n}"
end

Factory.define :page do |p|
  p.title "My page"
end

Factory.define :file, :class => UploadedFile do |f|
  f.current_version_id 0
end

Factory.define :file_version do |f|

end

Factory.define :user do |u|
  u.name "User"
  u.username { Factory.next(:username) }
end