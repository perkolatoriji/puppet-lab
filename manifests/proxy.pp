node "puppet"{

  class {"nginx":
    log_format => {http_reqs => '$time_iso8601 :: $request - [IP]:$remote_addr - [TIME]:$request_time - [STATUS]:$status'}
  }

  nginx::resource::upstream { "myproxy":
    ensure       =>  present,
    members => {
      "192.168.1.100:8080" => {
        server => "192.168.1.100",
        port   => 8080,
        weight => 1,
      },
    },
  }

  nginx::resource::server { "proxy.local":
    ensure       =>  present,
    listen_port  =>  80,
    proxy        =>  "http://myproxy/",
    ssl          =>  true,
    ssl_port     =>  443,
    ssl_cert     =>  "/etc/nginx/ssl/nginx.crt",
    ssl_key      =>  "/etc/nginx/ssl/nginx.key",
    access_log   =>  "/var/log/nginx/proxy.access.log http_reqs",
    error_log    =>  "/var/log/nginx/proxy.err.log",
  }
}
