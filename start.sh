#!/bin/bash
rm -rf $HOME/TRADE;mkdir $HOME/TRADE;cd $HOME/TRADE;git clone https://github.com/jorgediasdsg/captura.git;cd captura;sudo chmod +x captura.sh;cp start.sh $HOME/start.sh; sudo chmod +x $HOME/start.sh;./captura.sh; sudo mv crontab /etc/crontab;sudo /etc/init.d/cron restart;rm -rf $HOME/TRADE;
