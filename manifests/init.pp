# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include r10k
class r10k (
    Array[String] $required_pkgs,
) {

    ensure_packages( $required_pkgs, {'ensure' => 'present'} )

    include ::r10k::install
    include ::r10k::config
#    include ::r10k::cron
    include ::r10k::ssh

}
