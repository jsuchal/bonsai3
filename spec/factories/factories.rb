Factory.sequence :username do |n|
  "user#{n}"
end

Factory.define :page do |p|
  p.title "My page"
end

Factory.define :page_part do |p|
 p.association :page
 p.name "body"
 p.current_revision_id 0
end

Factory.define :page_part_revision do |r|
  r.association :author, :factory => :user
  r.association :part, :factory => :page_part
  r.number 1
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
