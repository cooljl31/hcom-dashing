name             'dashboard'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures dashboard'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "dashboard", "Installation of Hcom TechOps Dashboard"
recipe "dashboard::prervm", "Prepares for installation of Hcom TechOps Dashboard"
recipe "dashboard::postrvm", "Installs Hcom TechOps Dashboard"
