class base::execs {
  @exec { "yum_clean_all":
    path        => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
    command     => "yum clean all",
    refreshonly => true,
  }
}
