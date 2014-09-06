#
# Courtesy of DeltaMuAlpha https://gist.github.com/deltamualpha
# https://gist.github.com/deltamualpha/c3a191260352f24eb74e
#
define php::confd {
  if $::lsbdistcodename == 'precise' {
    $php_build = '20090626'

    file { "/etc/php5/cli/conf.d/${title}.ini":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("php/conf.d/${title}.ini")
    }
  } elsif $::lsbdistcodename == 'trusty' {
    $php_build = '20121212'

    file { "/etc/php5/mods-available/${title}.ini":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("php/conf.d/${title}.ini")
    }

    if defined(Package['libapache2-mod-php5']) {
      file { "/etc/php5/apache2/conf.d/20-${title}.ini":
        ensure  => link,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        target  => "/etc/php5/mods-available/${title}.ini",
        require => [File["/etc/php5/mods-available/${title}.ini"], Package['libapache2-mod-php5']]
      }
    }

    if defined(Package['php5-fpm']) {
      file { "/etc/php5/fpm/conf.d/20-${title}.ini":
        ensure  => link,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        target  => "/etc/php5/mods-available/${title}.ini",
        require => [File["/etc/php5/mods-available/${title}.ini"], Package['php5-fpm']]
      }
    }

    file { "/etc/php5/cli/conf.d/20-${title}.ini":
      ensure  => link,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      target  => "/etc/php5/mods-available/${title}.ini",
      require => File["/etc/php5/mods-available/${title}.ini"]
    }
  }
}
