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

you first need to setup the time for password change. you can do it by using the followings command :

```
sudo chage -m 2 -M 30 -W 7 root 
sudo chage -m 2 -M 30 -W 7 YOURUSER
```
