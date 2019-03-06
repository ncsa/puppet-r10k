# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include r10k::user
class r10k::user {

    # Get values from r10k top level
    $r10k_user  = lookup( 'r10k::user' )
    $r10k_group = lookup( 'r10k::group' )

    # Some defaults
    $file_defaults = {
        'ensure' => 'directory',
        'owner'  => $r10k_user,
        'group'  => $r10k_group,
        'mode'   => '0750',
    }

    user { $r10k_user :
        ensure     => present,
        managehome => true,
    }

    group { $r10k_group :
        ensure     => present,
    }
}
