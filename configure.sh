#!/bin/sh

# configs
mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt
wget $IndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/
wget -qO- $CONFIGCADDY | sed -e "1c :$PORT" -e "s/\$UUID/$UUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $UUID)/g" >/etc/caddy/Caddyfile
wget -qO- $CONFIGXRAY | sed -e "s/\$UUID/$UUID/g" >/config.json

# storefiles
mkdir -p /usr/share/caddy/$UUID && wget -O /usr/share/caddy/$UUID/StoreFiles $StoreFiles
wget -P /usr/share/caddy/$UUID -i /usr/share/caddy/$UUID/StoreFiles

for file in $(ls /usr/share/caddy/$UUID); do
    [[ "$file" != "StoreFiles" ]] && echo \<a href=\""$file"\" download\>$file\<\/a\>\<br\> >>/usr/share/caddy/$UUID/ClickToDownloadStoreFiles.html
done

# start
tor &

/xray -config /config.json &

caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
