class web($latest = "1.3") {
  file { "/etc/httpd/conf.d/welcome.conf":
    ensure => absent
  }

  file { "/var/www/vhosts/web_theforeman.org":
    ensure => link,
    target => "/var/www/cap/theforeman.org/current/_site/",
  }

  apache::vhost { "web":
    ensure         => present,
    config_content => template("web/web.conf.erb"),
    require        => File["/var/www/vhosts/web_theforeman.org"],
  }

  apache::vhost { "yum":
    ensure => present,
    config_file => "puppet:///modules/web/yum.theforeman.org.conf"
  }

  if $osfamily == 'RedHat' {
    package { 'createrepo':
      ensure => present,
    }
  }

  file { "/var/www/vhosts/yum/htdocs/releases/latest":
    ensure => link,
    target => $latest,
  }
}
