namespace :bonsai do
  desc "Install new layout"
  task :install do

    if !ENV['layout'].nil?
      if File.exist? ENV['layout']
        cp "#{ENV['layout']}", "#{Rails.root}/vendor/layouts"
        #prepare file name
        file_name = File.basename("#{ENV['layout']}")
        #prepare dir name
        dir_name = file_name[0, file_name.index('.')]
        FileUtils.chdir("#{Rails.root}/vendor/layouts")
        `tar -xvf #{file_name}`

        error = false
        unless File.exist? ("#{dir_name}/definition.yml")
          puts "ERROR: #{dir_name}/definition.yml does not exist!"
          error = true
        end
         unless File.exist? ("#{dir_name}/#{dir_name}.html.erb")
          puts "ERROR: #{dir_name}/#{dir_name}.html.erb does not exist!"
          error = true
        end
        unless File.exist? ("#{dir_name}/locales")
          puts "ERROR: #{dir_name}/locales does not exist!"
          error = true
        end
        unless File.exist? ("#{dir_name}/public")
          puts "ERROR: #{dir_name}/public does not exist!"
          error = true
        end

        if error != true
          #move images
          mv "#{Rails.root}/vendor/layouts/#{dir_name}/public/images", "#{Rails.root}/public/images/layouts/#{dir_name}"
          #move stylesheet definition
          mv "#{Rails.root}/vendor/layouts/#{dir_name}/public/#{dir_name}.css", "#{Rails.root}/public/stylesheets/"
          #move language definitions
          mv "#{Rails.root}/vendor/layouts/#{dir_name}/locales", "#{Rails.root}/config/locales/layouts/#{dir_name}"
          #move html erb file
          mv "#{Rails.root}/vendor/layouts/#{dir_name}/#{dir_name}.html.erb", "#{Rails.root}/app/views/layouts/"
          #remove public folder
          rm_rf "#{Rails.root}/vendor/layouts/#{dir_name}/public"
          #remove archive
          rm_rf "#{Rails.root}/vendor/layouts/#{file_name}"

          puts "Layout #{dir_name} was successfully installed."
        end

      else
        puts "ERROR cant find this file, please check tha path"
      end
    else
      puts "ERROR: You must specify layout to install"
    end
  end


  desc "Uninstall layout"
  task :uninstall => :environment do


    if !ENV['layout'].nil?
      pages = Page.all(:select => "lft, rgt", :conditions => ["layout = ?", ENV['layout']], :order => 'id asc')
      if pages.empty?
        path = "#{Rails.root}/public/images/layouts/#{ENV['layout']}"
        if  File.exist? path
          rm_rf path
        end

        path = "#{Rails.root}/public/stylesheets/#{ENV['layout']}.css"
        if  File.exist? path
          rm_rf path
        end

        path = "#{Rails.root}/app/views/layouts/#{ENV['layout']}.html.erb"
        if  File.exist? path
          rm_rf path
        end

        path = "#{Rails.root}/config/locales/layouts/#{ENV['layout']}"
        if  File.exist? path
          rm_rf path
        end

        path = "#{Rails.root}/vendor/layouts/#{ENV['layout']}"
        if  File.exist? path
          rm_rf path
        end

        puts "Layout #{ENV['layout']} was successfully removed."
      else
        puts "ERROR: Layout can not be removed. This layout is currently used here:"
        pages.each do |page|
          puts page.get_path
        end
      end
    else
      puts "ERROR: You must specify layout to uninstall."
    end
  end

end