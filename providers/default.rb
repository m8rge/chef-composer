action :install do
    ohai "reload_passwd" do
        plugin "passwd"
    end

    target_dir = new_resource.target_dir ? new_resource.target_dir : ::File.join(node['etc']['passwd'][new_resource.owner]['dir'], 'bin')
    Chef::Log.info("Deploy composer to: #{target_dir}")

    directory target_dir do
        owner new_resource.owner
        group new_resource.group
        mode 0755
        recursive true
        action :create

        not_if "test -d #{target_dir}"
    end

    remote_file "#{target_dir}/composer.phar" do
        source new_resource.source
        owner new_resource.owner
        group new_resource.group
        mode 0755

        action :create_if_missing
    end

    new_resource.updated_by_last_action(true)
end

action :update do
    ohai "reload_passwd" do
        plugin "passwd"
    end

    target_dir = new_resource.target_dir ? new_resource.target_dir : ::File.join(node['etc']['passwd'][new_resource.owner]['dir'], 'bin')
    Chef::Log.info("Upgrade composer in location: #{target_dir}")

    execute "upgrade composer" do
        user new_resource.owner
        group new_resource.group
        cwd target_dir
        command "./composer.phar self-update --no-ansi --no-interaction"
        environment ({"HOME" => node['etc']['passwd'][new_resource.owner]['dir']})
    end

    new_resource.updated_by_last_action(true)
end
