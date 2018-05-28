#!/bin/bash -exu
#AUTOR JORGE DIAS jorgediasdsg@gmail.com https://github.com/jorgedsdsg/captura
e(){ echo $1; }; p(){ clear; seq 7 8 180 | paste -sd \X; e ""; e " SISTEMA CAPTURA DE TELA E ENVIO DE EMAIL"; e ""; e "	$1"; e ""; seq 7 8 180 | paste -sd \X; }
d=$(date +%d-%m-%Y-%X); s=sites.txt; m=emails.txt; l=$HOME/git/captura
cap(){ grep -v "^#" $s > site; while read n k; do d=$(date +%d-%m-%Y-%X); google-chrome-stable $k; e "$n - $d - $k" >> r; sleep 4; gnome-screenshot -f $l/$n-$d.png; done < site; }
cmail(){ e "-----------------------------------------------" > $l/c; e "RELATORIO DE SITES ACESSADOS" >> $l/c
e "" >> $l/c; cat r >> $l/c; e "" >> $l/c; e "PARTICIPANTES" >> $l/c; e "" >> $l/c; e $m >> $l/c; e "" >> $l/c
e "ATT NELSON BORCHARDT" >> $l/c; e "-----------------------------------------------" >> $l/c; }
ganexo(){ zip $l/$d.zip $l/*.png; rm $l/*.png; }
smail(){ grep -v "^#" $m > y; while read z n WHATS; do mutt -s "$n - SEU RELATORIO TRADE DE $d" $z < c -a $l/*.zip; done < y; }
rtemp(){ rm -rf $l/*.zip $l/email.txt $l/c $l/y $l/r $l/site; killall chrome; p "SESSAO ENCERRADA, PODE VOLTAR A TOMAR CAFÉ"; }
cap; cmail; ganexo; smail; rtemp
