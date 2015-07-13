#!/bin/bash
if [[ -n $BAMBOO_DOCKER_AUTO_HOST ]]; then
sed -i "s/^.*Endpoint\": \"\(http:\/\/haproxy-ip-address:8000\)\".*$/    \"EndPoint\": \"http:\/\/$HOST:8000\",/" \
    ${CONFIG_PATH:=config/production.example.json}
fi

# Replace env variables
for f in /etc/haproxy/errors/*.http
do
    # Replace ${VAR} with variables set in environment.
    perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' $f > "${f}.tmp"
    mv "${f}.tmp" $f
done

exec /usr/bin/supervisord
