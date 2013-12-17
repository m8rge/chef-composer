actions :install, :update, :create_project, :create, :dump_autoload

default_action :install

attribute :project_path, :kind_of => [String, NilClass], :name_attribute => true
attribute :home, :kind_of => String
attribute :user, :kind_of => [String, Integer]
attribute :group, :kind_of => [String, Integer]
attribute :composer_dir, :kind_of => [String, NilClass]
attribute :verbose, :equal_to => [true, false], :default => false
attribute :dev, :equal_to => [true, false], :default => false
attribute :prefer_dist, :equal_to => [true, false], :default => false
attribute :prefer_source, :equal_to => [true, false], :default => false
attribute :optimize_autoloader, :equal_to => [true, false], :default => false
attribute :no_scripts, :equal_to => [true, false], :default => false
