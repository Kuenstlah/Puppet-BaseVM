class base::packages (
  $default_packages = undef,
) {

  validate_array($default_packages)
  ensure_packages($default_packages)
  include base::execs

  package {'epel-release':
    name    => "epel-release",
    ensure  => latest,
    notify  => Exec['yum_clean_all'],
  }

}
