# Install r10k ruby gem
#
# @summary Install r10k ruby gem
#
class r10k::install (
    String $version,
    String $exec_wrapper_fn,
) {

    # Install r10k package
    package { 'r10k' :
        ensure   => $version,
        provider => 'puppet_gem',
    }

    # Get values from r10k top level
    $user              = lookup( 'r10k::user' )
    $group             = lookup( 'r10k::group' )
    $r10k_executable   = lookup( 'r10k::executable' )
    $r10k_pidfile      = lookup( 'r10k::pidfile' )

    # Set some useful defaults
    $file_defaults = { 'ensure' => 'file',
                       'owner'  => $user,
                       'group'  => $group,
                       'mode'   => '0750',
                     }

    # Install shell wrapper script
    # assume parent dir exists, not going to ensure it
    file {
        $exec_wrapper_fn:
            content => epp( 'r10k/r10k_exec_wrapper_script.epp',
                            { 'r10k_executable' => $r10k_executable,
                              'r10k_pidfile'    => $r10k_pidfile,
                            },
                          ),
        ;
        default:
            * => $file_defaults,
        ;
    }

}
