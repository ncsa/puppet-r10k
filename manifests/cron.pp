# Run r10k periodically
#
# @summary Run r10k periodically
#
class r10k::cron (
    Hash   $defaults,
) {

    # Get values from r10k top level
    $user         = lookup( 'r10k::user' )
    $exec_wrapper_fn = lookup( 'r10k::install::exec_wrapper_fn' )


    # Cron Defaults
    $cron_defaults = $defaults + {
        'user'        => $user,
        'environment' => [ 'DATE=date +%y%m%d_%H%M%S' ],
    }


    # Ensure a place to log cron output
    $user_home = $user ? {
        'root'  => '/root',
        default => "/home/${user}"
    }
    $cronlogs = "${user_home}/cronlogs"
    ensure_resource( 'file', $cronlogs, { ensure   => 'directory',
                                          owner    => $user,
                                          mode     => '0700',
                                        }
    )


    # Create cron job
    $command = "${exec_wrapper_fn} 1>${cronlogs}/\$(\$DATE)_r10k_deploy.log 2>&1"
    cron {
        'r10k deploy environment' :
            command => $command,
        ;
        default:
            * => $cron_defaults,
        ;
    }

}
