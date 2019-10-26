#!/usr/bin/env bash
sudo cp /home/lov/lov/notes/nginx/nginx.conf /etc/nginx/.
sudo cp /home/lov/lov/notes/nginx/lov_is.conf /etc/nginx/conf.d/.
sudo /usr/sbin/nginx -t
sudo service nginx restart