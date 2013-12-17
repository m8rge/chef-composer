action :install do
    log "Install package in directory: #{new_resource.project_path}"
    composer_dir = ::File.join(new_resource.home, 'bin')
    composer_bin = ::File.join(composer_dir, 'composer.phar')
    arguments = initialize_arguments(new_resource)

    execute "install-composer-packages" do
        user new_resource.user
        group new_resource.group
        cwd new_resource.project_path
        command composer_bin + " install #{arguments}"
        environment ({'HOME' => new_resource.home})

        only_if composer_bin + " help"
        not_if "test -f " + ::File.join(new_resource.project_path, 'composer.lock')
    end

    new_resource.updated_by_last_action(true)
end

action :update do
    log "Update package: #{new_resource.project_path}"
    composer_dir = ::File.join(new_resource.home, 'bin')
    composer_bin = ::File.join(composer_dir, 'composer.phar')
    arguments = initialize_arguments(new_resource)

    execute "update-composer-packages" do
        user new_resource.user
        group new_resource.group
        cwd new_resource.project_path
        command composer_bin + " update #{arguments}"
        environment ({'HOME' => new_resource.home})

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
