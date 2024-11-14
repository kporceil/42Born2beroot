# BORN2BEROOT
Born2beroot is one of the second circle projects of 42 school.
On this project, we gonna discover Virtual machine and how to set a proper environment with strict rules.

## First step : Install Debian

Create a new Virtual Machine in Oracle Virtual Box.
Add debian iso to the virtual machine and start it.
Do the setup by creating LVM encrypted partition table, add the two srv and var-log volume for the bonus part.
Reboot and login as root user.

## Second step : set sudo

if sudo is not pre-installed, install it with ```apt install sudo```.
when sudo is installed use ```visudo``` for open the config file of sudo and add the following instructions :
```
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin" # secure the paths who is in the subjects
Defaults        passwd_tries=3 # set the max attempt to 3
Defaults        badpass_message="Wrong Password." # set the custom phrase when wrong password is set
Defaults        log_input, log_output # enable logging the input and output of sudo
Defaults        logfile="/var/log/sudo/sudo.log" # set the general log file
Defaults        iolog_dir="/var/log/sudo" # set the dir for all the log, ENSURE /var/log/sudo IS CREATED
Defaults        requiretty # set TTY mode
```

## Third step : set ssh

if ssh is not pre-installed install it with ```apt install ssh-server```.
edit the config file in ```/etc/ssh/sshd_config``` and set the following instructions :

```
Port 4242
PermitRootLogin no
```

## Fourth step : set UFW

UFW is the basic firewall of debian, we need to set it to allow only port 4242 for ssh and disable all others incomming connexions.
if UFW is not pre-installed, install it with :

```apt install ufw```

now, we can set up ufw with these commands :
```
ufw allow 4242/tcp #allow the port for ssh
ufw default deny incoming #deny all incoming connexion by default
ufw default alloy outgoing #alloy all outgoing connexion by default (deny all outgoing connexion can cause several problems in your machine)
ufw enable # enable UFW
```

you can now check the configuration of ufw by
```
ufw status verbose
```

You probably need to change a little this configuration if you want to do the bonuses.

You now can connect to your VM with ssh for the rest of this guide

## Fifth step : set group

for the project, you need to create a group named user42 and add your user to this group, you also need to add your user to the sudo group.
just follow theses commands :

```
sudo groupadd user42
sudo usermode -aG user42 YOURUSER
sudo usermode -aG sudo YOURUSER
```

## Sixth step : set strong password policy

for the project, you need to set a strong password policy.

you first need to setup the time for password change. you can do it for actual users by using the followings command :

```
sudo chage -m 2 -M 30 -W 7 root 
sudo chage -m 2 -M 30 -W 7 YOURUSER
```
you need to set this rules by add the following lines to ```/etc/login.defs``` :
```
PASS_MAX_DAYS   30
PASS_MIN_DAYS   2
PASS_WARN_AGE   7
```

after that, you need to set the restrictions for the password.
you need to install the libpam_pwquality with ```sudo apt install libpam_pwquality```
then, edit the ```/etc/pam.d``` for set this line :

```
password        requisite                       pam_pwquality.so retry=3 minlen=10 difok=7 ucredit=-1 lcredit=-1 dcredit=-1 reject_username enforce_for_root
```


## Seventh step : monitoring.sh

you need to write a script in shell conforming to the subject.
then, for setting up the 10 min interval, you need to install cron and wall by the following command :
```
sudo apt install cron
sudo apt install wall
```

then, edit the configuring file of cron with ```crontab -e``` and add the following line :

```
*/10 * * * * bash PATH_TO_YOUR_SCRIPT | wall
```

after that, you have finish the mandatory part. Now, this is how to make the bonuses :

## Eighth step : MariaDB

You first need to install MariaDB with ```sudo apt install mariadb-server```.
then, secure the MariaDB installation with ```sudo mysql_secure_installation```
set a password for root user, delete anonym users, disabled root remote connexion and delete the test database.
then, launch Mysql as root with ```sudo mysql -u root -p```
you need to create a new database for wordpress and a new user for this database.
do it with :
```
CREATE DATABASE name of the database DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci; #create the database and set the locales
CREATE USER 'name of the user'@'localhost' IDENTIFIED BY 'user password'; #create the user for the database with the password
GRANT ALL PRIVILEGES ON name of the databse.* TO 'your user'@'localhost'; #enable your user to access the database
FLUSH PRIVILEGES; #enable the new privileges set
EXIT; #quit mysql
```

## Ninth step : Lighttpd

Install it with ```sudo apt install lighttpd```
set the port you want by edit the ```/etc/lighttpd/lighttpd.conf``` file.
now enable and start the service by :
```
sudo systemctl enable lighttpd
sudo systemctl start lighttpd
```
## Tenth step : PHP

install PHP and all the modules for wordpress with ```sudo apt install php php-cgi php-mysql php-gd php-curl -y```
enable fastcgi and fastcgi-php for lighttpd with : 
```
sudo lighty-enable-mod fastcgi
sudo lighty-enable-mod fastcgi-php
```
restart lighttpd for apply changes by ```sudo systemctl restart lighttpd```

## Eleventh step : wordpress

download the last releases of wordpress with :
```
wget https://wordpress.org/latest.tar.gz
```
now extract it with :
```
tar xzvf latest.tar.gz
```
now set the default template as config by :
```
mv wordpress/wp-config-sample.php wordpress/wp-config.php
```
edit the conf file and set your DB info by :
```
nano wordpress/wp-config.php
```
now, move the wordpress folder to lighttpd and set the good perms with :
```
mv wordpress /var/www/html/
sudo chown -R www-data:www-data /var/www/html/wordpress
sudo chmod -R 755 /var/www/html/wordpress
```
don't forget to edit the UFW rules in accord to your lighttpd port settings.
now, you normally can access your website with ```http://localhost:LIGHTTPDPORT/wordpress```

## Last step

Install the service of your choice in your server !
