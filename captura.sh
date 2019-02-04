#!/bin/bash -exu
#
#AUTOR JORGE DIAS jorgediasdsg@gmail.com https://github.com/jorgedsdsg/captura
#
#Sistema de captura e envio de pares de moedas.
#
#Versão 0.5 Captura printscreen de lista de sites e envia para e-mail.
#Versão 0.6 Captura Valores de lista de sites e envia para e-mail.
#Versão 1.0 Captura Valores e pdf de lista de sites e envia para e-mail.
#Versão 1.5 12/01/2019 - Captura Valores e pdf de lista de sites e grava em planilha online.
#Versão 1.6 22/01/2019 - Colocado data atual.
#Versão 1.7 23/01/2019 - Adicionado alguns gráficos;
#Versão 2   24/01/2019 - Feito migração para gráficos da planilha base
#Versão 2.1 27/01/2019 - Sistema redundância (Origem)
#Versão 2.2 03/02/2019 - Instalado e Testado 2º Rasp Redundante.
#Versão 2.3 03/02/2019 - Removida as chaves do Telegram e Google do Git.
#Versão 2.4 03/02/2019 - Código refatorado.
#
cd $HOME/TRADE/captura 						#Local de Execução
lista_sites=sites.txt  								#Chama o arquivos com sites.
lista_emails=emails.txt 								#Chama o arquivo com e-mails.
l=`pwd`										#Localiza a pasta atual do sistema.
d=$(date +%d/%m/%Y\ %X) 					#Captura a data do sistema para nomear os arquivos.
h=$(date +"%H")
diaatual=$(date +%d/%m/%Y)
diaseguinte=$(date -d "+1 days")
origem=$HOSTNAME
echo "LOG DE $diaatual" > log.txt
echo "Executando o sistema. Aguarde que pode demorar um pouco"
captura(){
	grep -v "^#" $lista_sites > sites
	while read site link; do 				#Abre o laço de execução dos screenshots.
		d=$(date +%d/%m/%Y\ %X)
		wget -q $link -O "$site.html"
		valor=`cat "$site.html" | grep "last_last" | sed "s/<\/span>.*// ; s/.*>//"`
		variacao=`cat "$site.html" | grep "pc\" dir=\"ltr\"" | sed "s/<\/span>.*// ; s/.*\"ltr\">//"`
		porcentagem=`cat "$site.html" | grep "pcp parentheses\" dir=\"ltr\"" | sed "s/<\/span>.*// ; s/.*ltr\">//"`
		echo "$site	$diaatual	$valor 	$variacao	$porcentagem" | sed "s/___/ /; s/%//" >> corpo_email.txt
		echo "" >> corpo_email.txt
		echo "$site;	$diaatual;	$valor;	$variacao;	$porcentagem;" | sed "s/___/ /; s/%//" >> $HOME/dd.csv
		paste <(grep "data-real-valu" $site.html | sed "s/<\/td>.*// ; s/.*\">//" | sed "s/ var.*//" | xargs -n 5) <(grep "\<td\> class=\"bold" $site.html | sed 's/<\/td>.*/ '$site'/ ; s/.*\">/ /') >> $HOME/hist.csv
		porcentagem_fechamento=$(grep "\<td\> class=\"bold" $site.html | head -2 | tail -1 | sed 's/<\/td>.*// ; s/.*\">//')
		data_fechamento=$(grep "data-real-valu" $site.html | head -1 | tail -1 | sed "s/<\/td>.*// ; s/.*\">//" | sed "s/ var.*//" | xargs -n 5 | sed "s/\./\// ; s/\./\//")
		wget -q "$(cat $HOME/google.cfg)&entry.1481241936=$site&entry.338287161=$diaatual&entry.1056328059=$valor&entry.196043540=$variacao&entry.1268065653=$porcentagem&entry.1463811894=$h&entry.80433284=$porcentagem_fechamento&entry.493625541=$data_fechamento&entry.1887060639=$origem" -O "$site1.html"
		#xvfb-run wkhtmltopdf $link $site.pdf		#CAPTURA DO SITE DIRETO PARA O PDF, desculpa python, php.
		echo "$diaatual | $h horas | $origem | $site | Feito!";
	done < sites ;						# Chama o arquivo sites.txt para o laço.
		sort $HOME/hist.csv | uniq > $HOME/historico.txt;
		sort $HOME/dd.csv | uniq | sed "s/___/ /" > $HOME/corpo_email.txt;

}
cria_email(){ 							#Modelo de e-mail que será enviado
	echo "-----------------------------" > corpo 
	echo "RELATORIO" >> corpo
	echo "" >> corpo
	echo "PAR--------DATA-----HORA----VALOR---VARIAÇÃO---%--->" >> corpo
	echo "" >> corpo
	cat corpo_email.txt >> corpo
	echo "" >> corpo
	echo "Acesse em:" >> corpo
	echo "https://goo.gl/Kohpyc" >> corpo
	echo "Sr' Robotrade, nice too meet you!." >> corpo
	echo "-----------------------------" >> corpo
}
envia_email(){
	#Envia mensagem no Telegram.
	wget -q "$(cat $HOME/telegram.cfg)Dados disponíveis de $diaatual $h horas. Origem: $origem. Acesse https://goo.gl/Kohpyc" -O TELEGRA.html;
	grep -v "^#" $lista_emails > emails_selecionados;
	while read email nome WHATS; do 
		mutt -s "$nome - SEU RELATORIO TRADE DE $diaatual $h " $email < corpo -a log.txt $HOME/corpo_email.txt $HOME/historico.txt;	done < emails_selecionados
}
remove_temporarios(){ rm -rf corpo emails_selecionados *.pdf log.txt *.html sites corpo_email.txt dados;};
captura
cria_email
envia_email
remove_temporarios
