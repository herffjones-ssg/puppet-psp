# == Class: psp
#
# This class handles installation of the HP Proliant Support Pack.
#
# === Parameters:
#
# [*smh_gid*]
#   The group ID of the SMH user.
#   Default: 490
#
# [*smh_uid*]
#   The user ID of the SMH user.
#   Default: 490
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# === Actions:
#
# Installs the SMH user and group as well as the YUM repository.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#   class { 'psp': }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2012 Mike Arnold, unless otherwise noted.
#
class psp (
  $ensure  = 'present',
  $smh_gid = $psp::params::gid,
  $smh_uid = $psp::params::uid
) inherits psp::params {

  case $ensure {
    /(present)/: {
      $user_ensure = 'present'
    }
    /(absent)/: {
      $user_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  case $::manufacturer {
    'HP': {
      @group { 'hpsmh':
        ensure => $user_ensure,
        gid    => $smh_gid,
      }

      @user { 'hpsmh':
        ensure => $user_ensure,
        uid    => $smh_uid,
        gid    => 'hpsmh',
        home   => '/opt/hp/hpsmh',
        shell  => '/sbin/nologin',
      }

    }
    # If we are not on HP hardware, do not do anything.
    default: { }
  }
}
