# doc
class centrify::cron {
  $_flush_cronjob_min       = $::centrify::flush_cronjob_min
  $_flush_cronjob_hour      = $::centrify::flush_cronjob_hour
  $_flush_cronjob_monthday  = $::centrify::flush_cronjob_monthday
  $_flush_cronjob_month     = $::centrify::flush_cronjob_month
  $_flush_cronjob_weekday   = $::centrify::flush_cronjob_weekday

  cron { 'flush_and_reload_centrify':
    ensure   => present,
    command  => '/usr/sbin/adflush &> /dev/null; /usr/sbin/adreload &> /dev/null',
    user     => 'root',
    minute   => $_flush_cronjob_min,
    hour     => $_flush_cronjob_hour,
    monthday => $_flush_cronjob_monthday,
    month    => $_flush_cronjob_month,
    weekday  => $_flush_cronjob_weekday,
  }
}
