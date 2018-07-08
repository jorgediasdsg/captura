#!/bin/bash
rm -rf $HOME/TRADE;
mkdir $HOME/TRADE;
cd $HOME/TRADE;
git clone https://github.com/jorgediasdsg/captura.git;
cd captura;
sudo chmod +x captura.sh;
./captura.sh;

#CRIANDO A CRON
echo "# /etc/crontab: system-wide crontab"	> novacrontab
echo "# Unlike any other crontab you don't have to run the \`crontab'"	>> novacrontab
echo "# command to install the new version when you edit this file"	>> novacrontab
echo "# and files in /etc/cron.d. These files also have username fields,"	>> novacrontab
echo "# that none of the other crontabs do."	>> novacrontab
echo ""	>> novacrontab
echo "SHELL=/bin/sh"	>> novacrontab
echo "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin"	>> novacrontab
echo ""	>> novacrontab
echo "# m h dom mon dow user	command"	>> novacrontab
echo "17 *	* * *	root    cd / && run-parts --report /etc/cron.hourly"	>> novacrontab
echo "25 6	* * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )"	>> novacrontab
echo "47 6	* * 7	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )"	>> novacrontab
echo "52 6	1 * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )"	>> novacrontab
echo ""	>> novacrontab
echo "30 21	* * 0	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 9	* * 1	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 11   * * 1	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 13   * * 1	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 15	* * 1	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 21	* * 1	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 9	* * 2	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 11	* * 2	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 13	* * 2	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 15	* * 2	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 21	* * 2	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 9	* * 3	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 11	* * 3	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 13	* * 3	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 15	* * 3	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 21	* * 3	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 9	* * 4	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 11	* * 4	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 13	* * 4	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 15	* * 4	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 21	* * 4	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 9	* * 5	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 11	* * 5	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 13	* * 5	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
echo "30 15	* * 5	root env DISPLAY=:0 bash $HOME/TRADE/captura/start.sh"	>> novacrontab
sudo mv novacrontab /etc/crontab
/etc/init.d/cron restart
