# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include r10k::ssh
class r10k::ssh (
    String $gitserver_host_key,
    String $public_key_contents,
    String $private_key_contents,
){

    # Get values from r10k top level
    $r10k_user  = lookup( 'r10k::user' )
    $r10k_group = lookup( 'r10k::group' )
    $gitserver  = lookup( 'r10k::git_server' )


    # Some defaults
    $file_defaults = {
        'ensure' => 'directory',
        'owner'  => $r10k_user,
        'group'  => $r10k_group,
        'mode'   => '0750',
    }


    # Create ssh key directory
    $ssh_dir = '/etc/puppetlabs/r10k/ssh'
    $dir_list = [ '/etc/puppetlabs/r10k', $ssh_dir ]
    ensure_resource( 'file', $dir_list, $file_defaults )


    # Install private & public ssh keys
    $pubkey_parts = split( $public_key_contents, ' ' )
    $pk_type = $pubkey_parts[0] ? {
        /(ecdsa|dsa|rsa|ed25519)/ => $1,
        default                   => $pubkey_parts[0],
    }
    $private_key = "${ssh_dir}/id_${pk_type}"
    $public_key = "${private_key}.pub"
    file {
        $private_key:
            ensure  => 'file',
            mode    => '0400',
            content => $private_key_contents,
        ;
        $public_key:
            ensure  => 'file',
            mode    => '0400',
            content => $public_key_contents,
        ;
        default:
            * => $file_defaults,
        ;
    }


    # Populate known_hosts
    $gs_key_parts = split( $gitserver_host_key, ' ' )
    sshkey { "r10k_known_hosts_${gitserver}":
        ensure => present,
        key    => $gs_key_parts[1],
        type   => $gs_key_parts[0],
    }

    # User SSH config
    $user_home = $r10k_user ? {
        'root'  => '/root',
        default => "/home/${r10k_user}"
    }
    #ensure parent dir
    $user_ssh_dir = "${user_home}/.ssh"
    ensure_resource( 'file',
                     $user_ssh_dir,
                     $file_defaults + { 'mode' => '0700' } )
    #adjust user ssh config
    $user_ssh_conf = "${user_ssh_dir}/config"
    $data = { 'User'                     => 'git',
              'PreferredAuthentications' => 'publickey',
              'IdentityFile'             => $private_key,
              'ForwardX11'               => 'no',
    }
    $data.each | $key, $val | {
        ssh_config{ "${r10k_user} ssh_config ${gitserver} ${key}":
            ensure => present,
            target => $user_ssh_conf,
            host   => $gitserver,
            key    => $key,
            value  => $val,
        }
    }
}
