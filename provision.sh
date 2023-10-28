#!/bin/bash

# Create user altschool on the Master node with root privileges
sudo useradd -m -G sudo altschool

# Set up SSH key-based authentication from Master to Slave
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
ssh-copy-id altschool@slave
ssh-keygen -R slave

# Copy contents from /mnt/altschool directory on Master to Slave
sudo rsync -avz /mnt/altschool/ altschool@slave:/mnt/altschool/slave

# Display overview of Linux process management on Master
top

# Install LAMP stack on Master and Slave
sudo apt-get update -y
sudo apt-get upgrade -y

# Install LAMP stack components

# Install PHP dependencies and PHP
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt install php8.1 -y
sudo apt install  -y php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-curl php8.1-xml php8.1-gd php8.1-mbstring
sudo apt-get update -y
sudo apt-get upgrade -y


# Install Apache and MySQL
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y mysql-server mysql-client pymysql
sudo systemctl start mysql

#sudo apt-get install -y apache2 libapache2-mod-php
sudo systemctl start apache2

# create root directory for index.php
sudo mkdir /var/www/projectlamp
sudo chown -R $USER:$USER /var/www/projectlamp

# create apache virtual host
echo "<VirtualHost *:80>
    ServerName projectlamp
    ServerAlias IP address
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/projectlamp
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/projectlamp.conf

# enable virtualhost
sudo a2ensite projectlamp

#disable default apache site
sudo a2dissite 000-default

#reload apache
sudo systemctl reload apache2

# Create a test PHP page
echo "<?php
phpinfo();" > index.php
sudo mv index.php /var/www/projectlamp

#reload apache
sudo systemctl reload apache2


# Install Nginx for Load Balancing
sudo apt-get install -y nginx
sudo apt-get install -y nginx
