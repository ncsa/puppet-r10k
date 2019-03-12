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

    $r10k_executable = lookup( 'r10k::executable' )
    $r10k_symlink = lookup( 'r10k::symlink' )

    # Create symlink
    file { $r10k_symlink:
        ensure => 'link',
        target => $r10k_executable,
    }

}
