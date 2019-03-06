# Install r10k ruby gem
#
# @summary Install r10k ruby gem
#
class r10k::install (
    String $version,
) {

    package { 'r10k' :
        ensure   => $version,
        provider => 'puppet_gem',
    }

    # Create symlink
    file { '/opt/puppetlabs/bin/r10k' :
        ensure => 'link',
        target => '/opt/puppetlabs/puppet/bin/r10k',
    }

}
