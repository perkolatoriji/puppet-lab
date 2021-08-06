node default {
  notify { 'before': }
  -> class { 'nginx': }
  -> notify { 'last': }
}
