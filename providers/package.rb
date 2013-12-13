action :install do
    Chef::Log.info("Install package in directory: #{new_resource.project_path}")
    composer_dir = new_resource.composer_dir ? new_resource.composer_dir : ::File.join(node['etc']['passwd'][new_resource.user]['dir'], 'bin')
    composer_bin = ::File.join(composer_dir, 'composer.phar')
    arguments = initialize_arguments(new_resource)

    ohai "reload_passwd" do
        plugin "passwd"
    end

    execute "install-composer-packages" do
        user new_resource.user
        group new_resource.group
        cwd new_resource.project_path
        command composer_bin + " install #{arguments}"
        environment ({'HOME' => node['etc']['passwd'][new_resource.user]['dir']})

        only_if composer_bin + " help"
        not_if "test -f " + ::File.join(new_resource.project_path, 'composer.lock')
    end

    new_resource.updated_by_last_action(true)
end

action :update do
    Chef::Log.info("Update package: #{new_resource.project_path}")
    composer_dir = new_resource.composer_dir ? new_resource.composer_dir : ::File.join(node['etc']['passwd'][new_resource.user]['dir'], 'bin')
    composer_bin = ::File.join(composer_dir, 'composer.phar')
    arguments = initialize_arguments(new_resource)

    ohai "reload_passwd" do
        plugin "passwd"
    end

    execute "update-composer-packages" do
        user new_resource.user
        group new_resource.group
        cwd new_resource.project_path
        command composer_bin + " update #{arguments}"
        environment ({'HOME' => node['etc']['passwd'][new_resource.user]['dir']})

        only_if composer_bin + " help"
    end

    new_resource.updated_by_last_action(true)
end

def initialize_arguments(new_resource)
    arguments = "--no-interaction --no-ansi"

    if new_resource.verbose
        arguments = " --no-interaction --verbose"
    end
    if new_resource.dev
        arguments += " --dev"
    else
        arguments += " --no-dev"
    end
    if new_resource.prefer_source
        arguments += " --prefer-source"
    end
    if new_resource.prefer_dist
        arguments += " --prefer-dist"
    end
    if new_resource.optimize_autoloader
        arguments += " --optimize-autoloader"
    end
    if new_resource.no_scripts
        arguments += " --no-scripts"
    end
    arguments
end
