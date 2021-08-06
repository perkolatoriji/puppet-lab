node "puppetclient"{

class {"nginx":
  log_format => {http_reqs => '$time_iso8601 :: $request - [IP]:$remote_addr - [TIME]:$request_time - [STATUS]:$status'}
}

  $web_site      = "domain.com"
  $dom_redir     = "https://10.10.10.10/"
  $redirect      = "/resource"
  $res_redir     = "https://20.20.20.20/"

  nginx::resource::server {"${web_site}":
    ensure       =>  present,
    ssl          =>  true,
    listen_port  =>  443,
    ssl_port     =>  443,
    ssl_cert     =>  "/etc/nginx/ssl/nginx.crt",
    ssl_key      =>  "/etc/nginx/ssl/nginx.key",
    proxy        =>  "${dom_redir}",
    access_log   =>  "/var/log/nginx/ssl-${web_site}.access.log http_reqs",
  }

  nginx::resource::location {"${redirect}":
    ensure       =>  present,
    ssl          =>  true,
    ssl_only     =>  true,
    server       =>  "${web_site}",
    proxy        =>  "${res_redir}",
  }

}
