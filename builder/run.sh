#!/bin/bash
if [[ -n $BAMBOO_DOCKER_AUTO_HOST ]]; then
sed -i "s/^.*Endpoint\": \"\(http:\/\/haproxy-ip-address:8000\)\".*$/    \"EndPoint\": \"http:\/\/$HOST:8000\",/" \
    ${CONFIG_PATH:=config/production.example.json}
fi

# Generate configuration by looping through .dist files in /etc/nginx/conf.d/default.conf
for f in /etc/haproxy/errors/*.html
do
    # Replace ${VAR} with variables set in environment.
    perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' $f > $f
done

haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid
exec /usr/bin/supervisord
