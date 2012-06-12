class __module__ (
    $ensure             = params_lookup('ensure'),
    $ensure_running     = params_lookup('ensure_running'),
    $ensure_enabled     = params_lookup('ensure_enabled'),
    $manage_config      = params_lookup('manage_config'),
    $config_file        = params_lookup('config_file'),
    $config_source      = params_lookup('config_source'),
    $config_template    = params_lookup('config_template'),
    $disabled_hosts     = params_lookup('disabled_hosts'),
    ) inherits __module__::params {

    package { '__module__':
        ensure => $ensure
    }

    service { '__module__':
        ensure      => $ensure_running,
        enable      => $ensure_enabled,
        hasrestart  => true,
        hasstatus   => true,
        require     => Package['__module__']
    }

    file { $config_file:
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        tag     => '__module___config'
    }

    # Disable service on this host, if hostname is in disabled_hosts
    if $::hostname in $disabled_hosts {
        Service <| title == '__module__' |> {
            ensure  => 'stopped',
            enabled => false,
        }
    }

    if $config_source {
        File <| tag == '__module___config' |> {
            source  => $config_source
        }
    } elsif $config_template {
        File <| tag == '__module___config' |> {
            template => $config_template
        }
    }
}
