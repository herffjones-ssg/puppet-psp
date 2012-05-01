# Class: psp::hpvca
#
# This class manages hpvca.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class psp::hpvca {
  package { "hpvca":
    ensure => $::operatingsystem ? {
      RedHat  => "present",
      default => "absent",
    },
    name   => "hpvca",
  }

#TODO: file or exec for hpvca configuration?

  service { "hpvca":
    name       => "hpvca",
    ensure     => $::operatingsystem ? {
      RedHat  => "running",
      default => "stopped",
    },
    enable     => $::operatingsystem ? {
      RedHat  => true,
      default => false,
    },
    hasrestart => true,
    hasstatus  => true,
    require    => Package["hpvca"],
  }
}