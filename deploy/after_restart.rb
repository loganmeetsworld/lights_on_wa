execute 'start whenever' do
  cwd release_path
  user node[:deploy][:lights_on_wa][:user] || 'deploy'
  command 'bundle exec whenever -i lights_on_wa'
end