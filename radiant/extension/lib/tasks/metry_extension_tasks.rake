namespace :radiant do
  namespace :extensions do
    namespace :metry do
      
      desc "Runs the migration of the Metry extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          MetryExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          MetryExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Metry to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from MetryExtension"
        Dir[MetryExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(MetryExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end
