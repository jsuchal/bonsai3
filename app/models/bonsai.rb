class Bonsai < Settingslogic
  source "#{Rails.root}/config/bonsai.yml"
  namespace Rails.env
end
