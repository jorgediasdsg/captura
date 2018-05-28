#!/bin/bash -exu
#AUTOR JORGE DIAS jorgediasdsg@gmail.com https://github.com/jorgedsdsg/captura
#PAINEL DE EXIBIÇÃO 
e(){ echo $1; }; p(){ clear; seq 7 8 180 | paste -sd \X
e ""; e " SISTEMA CAPTURA DE TELA E ENVIO DE EMAIL"; e ""; e "	$1"; e ""; seq 7 8 180 | paste -sd \X; }
#INSTALA CLIENTE DE E-MAIL
d=$(date +%d-%m-%Y-%X)
s=sites.txt
m=emails.txt
DIR=$HOME/git/captura
#LENDO ARQUIVOS DOS SITES
captura(){
	#p "LENDO ARQUIVOS DE SITES"
	grep -v "^#" $s > site
	while read NOME LINK; do
		d=$(date +%d-%m-%Y-%X)
		#p "ACESSANDO O SITE $LINK"
		google-chrome-stable $LINK
		e "$NOME - $d - $LINK" >> relatorio.txt
		#p "AGUARDANDO CAPTURA DE TELA"
		sleep 4
		#p "CAPTURANDO TELA"
		gnome-screenshot -f $DIR/$NOME-$d.png
	done < site
}
cria_email(){
	e "-----------------------------------------------" > $DIR/cmail
	e "RELATORIO DE SITES ACESSADOS" >> $DIR/cmail
	e "" >> $DIR/cmail
	cat relatorio.txt >> $DIR/cmail
	e "" >> $DIR/cmail
	e "$LINK FOI FEITA A CAPTURA" >> $DIR/cmail
	e "" >> $DIR/cmail
	e "ATT NELSON BORCHARDT" >> $DIR/cmail
	e "-----------------------------------------------" >> $DIR/cmail
}
gera_anexo(){
	p "ZIPANDO CAPTURAS"
	zip $DIR/$d.zip $DIR/*.png
	p "REMOVENDO CAPTURAS"
	rm $DIR/*.png
}
envia_email(){
	grep -v "^#" $m > email
	while read EMAIL NOME WHATS; do
		p "ENVIANDO EMAIL PARA $NOME"
		mutt -s "$NOME - SEU RELATORIO TRADE DE $d" $EMAIL < cmail -a $DIR/*.zip
	done < email
}
remove_temp(){
	p "REMOVENDO ANEXO"
	rm -rf $DIR/*.zip $DIR/email.txt $DIR/cmail $DIR/email $DIR/relatorio.txt $DIR/site
	p "FECHANDO CHROME"
	#killall chrome
	p "SESSAO ENCERRADA, PODE VOLTAR A TOMAR CAFÉ"
}
captura; cria_email; gera_anexo; envia_email; remove_temp
