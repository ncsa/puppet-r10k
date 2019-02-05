# Install r10k ruby gem
#
# @summary Install r10k ruby gem
#
class r10k::install (
    String $version,
) {

    package { 'ruby' :
        ensure   => $version,
        provider => 'gem',
    }

}
