# Install a phar file from a remote server directly
#
# Courtesy of DeltaMuAlpha https://gist.github.com/deltamualpha
# https://gist.github.com/deltamualpha/614e1799f97c8be298f8
#
define php::phar ($url, $insecure = false, $target = $title) {

	$split = split($url, '/')
	$filename = $split[-1]

  # for wget bug workarounds
  if ($insecure == true) {
    $wget_options = "--no-check-certificate"
  }

  exec { "download-phar-${title}":
		command     => "wget ${wget_options} ${url}",
    cwd         => '/var/tmp',
    path        => [ '/bin', '/usr/bin'],
    notify      => Exec["chmod-${filename}"],
    creates     => "/var/tmp/${filename}"
  }

  exec { "chmod-${filename}":
  	command     => "chmod +x ${filename}",
    cwd         => '/var/tmp',
    path        => [ '/bin', '/usr/bin'],
    notify      => Exec["cp-${filename}"],
    require     => Exec["download-phar-${title}"],
    refreshonly => true,
  }

  exec { "cp-${filename}":
  	command     => "cp ${filename} /usr/local/bin/${target}",
    cwd         => '/var/tmp',
    path        => [ '/bin', '/usr/bin'],
    require     => Exec["chmod-${filename}"],
    refreshonly => true,
  }
}
