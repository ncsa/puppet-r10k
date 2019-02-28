# Populate r10k.yaml config file
#
# @summary Populate r10k.yaml config file
#
class r10k::config (
    Hash $conf,
) {

    # Get values from r10k top level
    $user      = lookup( 'r10k::user' )
    $group     = lookup( 'r10k::group' )

    # Create r10k config directory
    $r10k_conf_dir = '/etc/puppetlabs/r10k'
    $file_defaults = { 'ensure' => 'directory',
                      'owner'  => $user,
                      'group'  => $group,
                      'mode'  => '2770',
                    }
    ensure_resource( 'file', $r10k_conf_dir, $file_defaults )

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
}
