class centrify::cron {
  cron { 'flush-centrify-cache':
    ensure  =>  present,
    command =>  '/usr/sbin/adflush -f > /dev/null 2>&1',
    user    =>  root,
    minute  =>  '*/30',
  }
}
