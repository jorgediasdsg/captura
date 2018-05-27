#!/bin/bash
#INSTALA CLIENTE DE E-MAIL
./mail.sh | tee log.txt
SITE=uol.com.br
DIA=$(date +%d-%m-%Y-%X)
DESTINO=meuemail@mmm.com
DIR=$HOME/git
echot(){
clear	
echo "-----------------------------------------------------------"
echo ""
echo "   SISTEMA DE CAPTURA DE TELA COM ENVIO DE EMAIL"
echo ""
echo "   $1"
echo ""
if [ -n "$2" ]; then
echo "   $2"
echo ""
fi
if [ -n "$3" ]; then
echo "   $3"
echo ""
fi
if [ -n "$4" ]; then
echo "   $4"
echo ""
fi
echo "-----------------------------------------------------------"
}
echo "--------------------" > $DIR/email.txt
echo "RELATORIO DE SITES ACESSADOS" >> $DIR/email.txt
echo "" >> $DIR/email.txt
echo "$SITE FOI FEITA A CAPTURA" >> $DIR/email.txt
echo "" >> $DIR/email.txt
echo "" >> $DIR/email.txt
echo "ATT FULANO DE TALS" >> $DIR/email.txt
echo "--------------------" >> $DIR/email.txt
echot "ACESSANDO O SITE $SITE"
google-chrome-stable http://$SITE
echot "AGUARDANDO CAPTURA DE TELA"
sleep 4
echot "CAPTURANDO TELA"
gnome-screenshot -f $DIR/$SITE-$DIA.png
echot "ZIPANDO CAPTURAS"
zip $DIR/$DIA.zip $DIR/*.png
echot "REMOVENDO CAPTURAS"
rm $DIR/*.png
echot "ENVIANDO EMAIL"
mutt -s "RELATORIO DO SITE $SITE" $DESTINO < email.txt -a $DIR/*.zip
echot "REMOVENDO ANEXO"
rm -rf $DIR/*.zip $DIR/email.txt
echot "FECHANDO CHROME"
#killall chrome
echot "SESSAO ENCERRADA, PODE VOLTAR A TOMAR CAFÉ"
