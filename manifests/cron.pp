class centrify::cron {
  $_crontab_time_min         = $::crontab_time_min
  cron { 'flush-centrify-cache':
    ensure  =>  present,
    command =>  '/usr/sbin/adflush -f > /dev/null 2>&1',
    user    =>  root,
    minute  =>  $_crontab_time_min,
  }
}
