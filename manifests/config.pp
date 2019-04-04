# Populate r10k.yaml config file
#
# @summary Populate r10k.yaml config file
#
class r10k::config (
    Hash $conf,
    String $puppet_codedir,
) {

    # Get values from r10k top level
    $user            = lookup( 'r10k::user' )
    $group           = lookup( 'r10k::group' )
    $r10k_executable = lookup( 'r10k::executable' )


    # Create r10k config directory
    $r10k_conf_dir = '/etc/puppetlabs/r10k'
    $file_defaults = { 'ensure' => 'directory',
                       'owner'  => $user,
                       'group'  => $group,
                       'mode'   => '0750',
                     }
    ensure_resources( 'file', { $r10k_conf_dir => $file_defaults }, $file_defaults )

    # Populate config file
    file {
        "${r10k_conf_dir}/r10k.yaml" :
            ensure  => file,
            mode    => '0550',
            content => template( 'r10k/r10k.yaml.erb' ),
        ;
        default:
            * => $file_defaults,
        ;
    }

    # Set ownership & perms on various dirs
    $dirs = { $conf['cachedir'] => {'mode' => '2775'},
              $puppet_codedir   => {'mode' => '2775'},
            }
    ensure_resources( 'file', $dirs, $file_defaults )

### ENABLE ONLY AFTER FIXING R10K POSTRUN SCRIPTS TO BE ABLE TO GET 
### USEFUL INFORMATION FROM "puppet config" COMMANDS WHEN RUN AS
### NON-ROOT OR NON-PUPPET
#
#    # Set ownership and setuid on r10k executable
#    #
#    # Also need to set (same) on r10k::install::exec_wrapper_fn
#    file {
#        $r10k_executable :
#            ensure  => present,
#            mode    => '4550',
#            require => Package[ 'r10k' ],
#        ;
#        default:
#            * => $file_defaults,
#        ;
#    }
}
