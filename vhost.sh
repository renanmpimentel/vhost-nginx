#!/bin/bash

echo "Server name (Ex.: project.local):"
read server

echo "Path (Ex.: /var/www/your-project):"
read path

echo "Wait ..."

echo "server {
	listen 127.0.0.1:80;
	
	charset utf-8;
 
	access_log /usr/share/nginx/access.log;
    error_log /usr/share/nginx/error.log;

	root $path;
	index index.php index.html index.htm;

	# Make site accessible from http://$server/
	server_name $server;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files \$uri \$uri/ =404;
		# Uncomment to enable naxsi on this location
		# include /etc/nginx/naxsi.rules
	}

	# Only for nginx-naxsi used with nginx-naxsi-ui : process denied requests
	#location /RequestDenied {
	#	proxy_pass http://127.0.0.1:8080;    
	#}

	#error_page 404 /404.html;

	# redirect server error pages to the static page /50x.html
	#
	#error_page 500 502 503 504 /50x.html;
	#location = /50x.html {
	#	root /usr/share/nginx/html;
	#}

	# pass the PHP scripts to FPM socket
	location ~ \.php\$ {
    		try_files \$uri =404;
 
    		fastcgi_split_path_info ^(.+\.php)(/.+)\$;
    		# NOTE: You should have \"cgi.fix_pathinfo = 0;\" in php.ini
     
    		fastcgi_pass php;
 
    		fastcgi_index index.php;
 
    		fastcgi_param SCRIPT_FILENAME ${path}\$fastcgi_script_name;
    		fastcgi_param DOCUMENT_ROOT $path;
 
			# send bad requests to 404
			fastcgi_intercept_errors on;
 
    		include fastcgi_params;
	}	
	
	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	#location ~ /\.ht {
	#	deny all;
	#}
}" > /etc/nginx/sites-available/$server


echo "Active VHOST $server"
ln -s /etc/nginx/sites-available/$server /etc/nginx/sites-enabled/$server

echo "Update hosts"
echo "127.0.1.1 $server www.$server" >> /etc/hosts

echo "Restart nginx";
service nginx restart

echo "Okay!";