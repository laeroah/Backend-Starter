
def do_cmd_in_all_apps
  APPS.each do |env_name, app|
    yield env_name, app
  end
end

def run_cmd(cmd = nil)
  Bundler.with_clean_env {
    if cmd.present?
      sh cmd
    elsif block_given?
      yield
    end
  }
end


namespace :heroku do
  APPS = {
      staging: {
          name: 'test-staging',
          git_branch: 'develop',
          git_remote: 'heroku-staging'
      },
      production: {
          name: 'test-pro',
          git_branch: 'master',
          git_remote: 'heroku-production'
      }
  }

  do_cmd_in_all_apps do |env_name, app|
    desc "部署#{env_name}环境到heroku #{app[:name]}"
    if env_name == :produciton
      task "deploy_#{env_name}" => [:set_staging_app, :push, :migrate, :restart, :tag]
    else
      task "#{env_name}_deploy" => [:set_staging_app, :push, :migrate, :restart]
    end


    desc "db migrate #{env_name}环境到heroku #{app[:name]}"
    task "#{env_name}_migrations" => [:set_staging_app, :push, :off, :migrate, :restart, :on, :tag]

    desc "rollback #{env_name}环境到heroku #{app[:name]}"
    task "#{env_name}_rollback" => [:set_staging_app, :off, :push_previous, :restart, :on]

    desc "restart #{env_name}环境到heroku #{app[:name]}"
    task "#{env_name}_restart" => [:restart]
  end


  # task :production_migrations => [:set_production_app, :push, :off, :migrate, :restart, :on, :tag]
  # task :production_rollback => [:set_production_app, :off, :push_previous, :restart, :on]

  do_cmd_in_all_apps do |env_name, app|
    task "set_#{env_name}_app" do
      puts "开始处理#{app[:name]}"
      APP = app
    end
  end

  desc '添加heroku git远程仓库'
  task :add_git_remote do
    do_cmd_in_all_apps do |env_name, app|
      puts "添加#{env_name}环境heroku仓库"
      run_cmd %Q(heroku git:remote -a #{app[:name]} -r #{app[:git_remote]})
    end
  end

  task :push do
    puts '部署网站到Heroku ...'
    run_cmd %Q(git push -f #{APP[:git_remote]} #{APP[:git_branch]}:master)
  end

  task :restart do
    puts '重启服务 ...'
    run_cmd %Q(heroku restart --app #{APP[:name]})
  end

  task :tag do
    release_name = "#{APP[:name]}_release-#{Time.now.utc.strftime('%Y%m%d%H%M%S')}"
    puts "Tagging release as '#{release_name}'"
    run_cmd %Q(git tag -a #{release_name} -m 'Tagged release')
    run_cmd %Q(git push --tags #{APP[:git_remote]})
  end

  task :migrate do
    puts '运行数据库脚本迁移 ...'
    run_cmd %Q(heroku run rake db:migrate --app #{APP[:name]})
  end

  task :off do
    puts 'Putting the app into maintenance mode ...'
    run_cmd %Q(heroku maintenance:on --app #{APP[:name]})
  end

  task :on do
    puts 'Taking the app out of maintenance mode ...'
    run_cmd %Q(heroku maintenance:off --app #{APP[:name]})
  end

  task :push_previous do
    prefix = "#{APP[:name]}_release-"
    releases = `git tag`.split("\n").select { |t| t[0..prefix.length-1] == prefix }.sort
    current_release = releases.last
    previous_release = releases[-2] if releases.length >= 2
    if previous_release
      puts "Rolling back to '#{previous_release}' ..."

      puts "Checking out '#{previous_release}' in a new branch on local git repo ..."
      puts `git checkout #{previous_release}`
      puts `git checkout -b #{previous_release}`

      puts "Removing tagged version '#{previous_release}' (now transformed in branch) ..."
      puts `git tag -d #{previous_release}`
      puts `git push #{APP[:git_remote]} :refs/tags/#{previous_release}`

      puts "Pushing '#{previous_release}' to Heroku master ..."
      puts `git push #{APP[:git_remote]} +#{previous_release}:master --force`

      puts "Deleting rollbacked release '#{current_release}' ..."
      puts `git tag -d #{current_release}`
      puts `git push #{APP[:git_remote]} :refs/tags/#{current_release}`

      puts "Retagging release '#{previous_release}' in case to repeat this process (other rollbacks)..."
      puts `git tag -a #{previous_release} -m 'Tagged release'`
      puts `git push --tags #{APP[:git_remote]}`

      puts 'Turning local repo checked out on master ...'
      puts `git checkout #{APP[:git_branch]}`
      puts 'All done!'
    else
      puts "No release tags found - can't roll back!"
      puts releases
    end
  end
end