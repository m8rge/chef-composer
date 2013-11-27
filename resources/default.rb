actions :install, :remove, :update

default_action :install

attribute :target_dir, :kind_of => String
attribute :owner, :kind_of => [String, Integer]
attribute :group, :kind_of => [String, Integer]
attribute :source, :kind_of => [String], :default => "https://getcomposer.org/composer.phar"
