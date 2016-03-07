[:schedule].each do |config_name|
  Chef::Log.info("Processing config for #{config_name}")
  begin
    template "#{release_path}/config/#{config_name}.rb" do |_config_file|
      variables(
        config_name => node[:deploy][:APP_NAME][:config_files][config_name]
      )
      local true
      source "#{release_path}/config/#{config_name}.rb.erb"
    end
  rescue => e
    Chef::Log.error e
    raise "Error processing config for #{config_name}: #{e}"
  end
end