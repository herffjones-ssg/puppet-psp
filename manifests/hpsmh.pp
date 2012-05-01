# Class: psp::hpsmh
#
# This class manages hpsmh.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class psp::hpsmh {
  package { "cpqacuxe":
    ensure => "present",
    name   => "cpqacuxe",
  }

  package { "hpdiags":
    ensure => "present",
    name   => "hpdiags",
    #require => Package["hpsmh"],
  }

  package { "hp-smh-templates":
    ensure => "present",
    name   => "hp-smh-templates",
    #require => Package["hp-snmp-agents"],
  }

  package { "hpsmh":
    ensure => "present",
    name   => "hpsmh",
  }

  # TODO: Figure out some dynamic way to use hpsmh-cert-host1
  file { "hpsmh-cert-host1":
    mode    => "644",
    owner   => "root",
    group   => "root",
    require => Package["hpsmh"],
    ensure  => "present",
    path    => "/opt/hp/hpsmh/certs/host1.pem",
    source  => "puppet:///modules/psp/host1.pem",
    notify  => Service["hpsmhd"],
  }

  file { "hpsmhconfig":
    mode    => "644",
    owner   => "root",
    group   => "root",
    require => Package["hpsmh"],
    ensure  => "present",
    path    => "/opt/hp/hpsmh/config/smhpd.xml",
    source  => [
      "puppet:///modules/psp/smhpd.xml-${::fqdn}",
      "puppet:///modules/psp/smhpd.xml",
    ],
    notify  => Service["hpsmhd"],
  }

#  exec { "smhconfig":
#    command => "/opt/hp/hpsmh/sbin/smhconfig --trustmode=TrustByCert",
#  }

  service { "hpsmhd":
    name       => "hpsmhd",
    ensure     => "running",
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package["hpsmh"],
  }
}