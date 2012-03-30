namespace :zann do
  desc 'Merge users with duplicated login name'
  task :remove_slash_login => :environment do
    CONFIG['cas_enabled'] = true
    users = User.find(:all)
    users_with_slash_in_login = 0
    users.each do |u|
      login = u.login.split('\\').last.downcase
      user = User.find_by_login(login)
      if user.nil?
        u.login = login # remove slash
        u.email = "#{login}@example.com" #update email
        u.save!
        puts "#{u.login} updated" 
        users_with_slash_in_login += 1
      end
    end
    puts "#{users_with_slash_in_login} users updated"
  end
  
  task :merge_users => :environment do
    CONFIG['cas_enabled'] = true
    users = User.find(:all)
    merged_users = 0
    users.each do |u|
      if u.login.include?('\\')
        login = u.login.split('\\').last.downcase
        user = User.find_by_login(login)
        merge_user(u, user)
        merged_users += 1
      end   
    end
    puts "#{merged_users} merged"
  end
  
  def merge_user(from, to)
    puts "### merge #{from.login} with #{to.login} ###"   
    # photo
    photos = Photo.find_all_by_creator_id(from.id)
    photos.each do |p|
      p.accepts_role 'creator', to
      p.accepts_no_role 'creator', from
      p.creator_id = to.id
      p.save(false)
      puts "update photo #{p.id} from user #{from.login} to #{to.login}"
    end
    
    # album
    albums = Album.find_all_by_creator_id(from.id)
    albums.each do |a|
      a.accepts_role 'album_admin', to
      a.accepts_no_role 'album_admin', from
      a.creator_id = to.id
      a.save!
      puts "update album #{a.id} from user #{from.login} to #{to.login}"
    end
    
    # comment
    comments = Comment.find_all_by_author_id(from.id)
    comments.each do |c|
      c.author_id = to.id
      c.save!
      puts "update comment #{c.id} from user #{from.login} to #{to.login}"
    end
    
    # zann
    zanns = Zann.find_all_by_zanner_id(from.id)
    zanns.each do |z|
      duplicated_zanns = Zann.find(:all, :conditions => ["zanner_id = ? AND zannee_id = ?", to.id, z.zannee_id])
      if(duplicated_zanns.count > 0)
        z.destroy
        puts "destroy duplicated zann #{z.id} from user #{from.login}"
      else
        z.zanner_id = to.id
        z.save!
        puts "update zann #{z.id} from user #{from.login} to #{to.login}"
      end
    end
  end
  
  task :update_zann_count => :environment do
    photos = Photo.find(:all)
    photos.each do |p|
      count = Zann.find(:all, :conditions => ["zannee_type = ? AND zannee_id = ?", 'photo', p.id]).count
      puts "update photo #{p.id} zann count from #{p.zanns_count} to #{count}"
      p.zanns_count = count
      p.save(false)
    end
  end

  task :delete_unused_users => :environment do
	  users = User.find(:all)
	  users_deleted = 0
	  users.each do |u|
		  if u.login.include?('\\')
			  login = u.login.split('\\').last.downcase
			  user = User.find_by_login(login)
			  if !user.nil?
				  puts "remove user #{u.login}"
				  photos = Photo.find_all_by_creator_id(u.id)
				  albums = Album.find_all_by_creator_id(u.id)
				  comments = Comment.find_all_by_author_id(u.id)
    			  zanns = Zann.find_all_by_zanner_id(u.id)
				  puts "(#{photos.count}, #{albums.count}, #{comments.count}, #{zanns.count})"
				  u.accepts_no_role 'owner', user
				  u.destroy
				  users_deleted += 1
			  end
		  end
	  end
	  puts "#{users_deleted} users deleted"
  end
end
