name             "composer"
maintainer       "m8rge"
maintainer_email "to.merge@gmail.com"
license          "MIT"
description      "Recipe to install PHP package manager"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rst'))
version          "0.9"

%w{ ubuntu debian centos redhat fedora }.each do |os|
    supports os
end
