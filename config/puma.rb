rackup "/var/www/voltrak/config.ru"
bind "tcp://0.0.0.0:80"
# pidfile "/var/run/voltrek.pid"
environment 'production'
quiet

threads 10, 50