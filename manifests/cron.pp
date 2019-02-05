# Run r10k periodically
#
# @summary Run r10k periodically
#
class r10k::cron (
    Hash   $defaults,
    String $verbosity,
) {

    # Get values from r10k top level
    $user      = lookup( 'r10k::user' )


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
    $r10k_path = '/opt/puppetlabs/puppet/bin/r10k'
    $r10k_cmd = "${r10k_path} deploy environment -p -v ${verbosity}"
    $command = "${r10k_cmd} 1>${cronlogs}/\$(\$DATE)_r10k_deploy.log 2>&1"
    cron {
        'r10k deploy environment' :
            command => $command,
        ;
        default:
            * => $cron_defaults,
        ;
    }

}
