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
#
cd $HOME/TRADE/captura
e(){ echo $1; } 							#Substitue echo por e
m(){ da=$(date +%d/%m/%Y\ %X); echo $da \| $1; echo $da \| $1 >> log.txt; }
d=$(date +%d/%m/%Y\ %X) 					#Captura a data do sistema para nomear os arquivos.
s=sites.txt  								#Chama o arquivos com sites.
m=emails.txt 								#Chama o arquivo com e-mails.
l=`pwd`										#Localiza a pasta atual do sistema.
h=$(date +"%H")
diaatual=$(date +%d/%m/%Y)
diaseguinte=$(date -d "+1 days")
echo "LOG DE $diaatual" > log.txt
captura(){
	grep -v "^#" $s > sites
	while read site link; do 				#Abre o laço de execução dos screenshots.
		d=$(date +%d/%m/%Y\ %X)
		m "$site | Capturando do par de $link"		
		wget -q $link -O "$site.html"
		m "$site | Extraindo informações do par"
		valor=`cat "$site.html" | grep "last_last" | sed "s/<\/span>.*// ; s/.*>//"`
		variacao=`cat "$site.html" | grep "pc\" dir=\"ltr\"" | sed "s/<\/span>.*// ; s/.*\"ltr\">//"`
		porcentagem=`cat "$site.html" | grep "pcp parentheses\" dir=\"ltr\"" | sed "s/<\/span>.*// ; s/.*ltr\">//"`
		m "$site | Gravando par no arquivo"
		e "$site	$diaatual	$valor 	$variacao	$porcentagem" | sed "s/___/ /; s/%//" >> dados.txt
		e "" >> dados.txt
		e "$site;	$diaatual;	$valor;	$variacao;	$porcentagem;" | sed "s/___/ /; s/%//" >> $HOME/dd.csv
		m "$site | Extraindo histórico do par no arquivo"
		paste <(grep "data-real-valu" $site.html | sed "s/<\/td>.*// ; s/.*\">//" | sed "s/ var.*//" | xargs -n 5) <(grep "\<td\> class=\"bold" $site.html | sed 's/<\/td>.*/ '$site'/ ; s/.*\">/ /') >> $HOME/hist.csv
		m "$site | Extraindo porcetagem do fechamento"
		porcentagem_fechamento=$(grep "\<td\> class=\"bold" $site.html | head -2 | tail -1 | sed 's/<\/td>.*// ; s/.*\">//')
		data_fechamento=$(grep "data-real-valu" $site.html | head -2 | sed "s/<\/td>.*// ; s/.*\">//" | sed "s/ var.*//" | xargs -n 5 | sed "s/\./\// ; s/\./\//")
		m "$site | Enviando dados para planilha online $site $data_fechamento $porcentagem_fechamento"
		wget -q "https://docs.google.com/forms/d/e/1FAIpQLScpBhnEEmURRQuC0hzPvgr8Katbbjo9scq-v7ZbY1egf87e_A/formResponse?ifq&entry.1481241936=$site&entry.338287161=$diaatual&entry.1056328059=$valor&entry.196043540=$variacao&entry.1268065653=$porcentagem&entry.1463811894=$h&entry.80433284=$porcentagem_fechamento&entry.493625541=$data_fechamento" -O "$site1.html"
		#wget -q "https://docs.google.com/forms/d/e/1FAIpQLScpBhnEEmURRQuC0hzPvgr8Katbbjo9scq-v7ZbY1egf87e_A/formResponse?ifq&entry.80433284=$porcentagem&entry.493625541=$diaatual&entry.1056328059=$valor&entry.1268065653=$porcentagem&entry.1463811894=$h" -O "$site1.html"
		#m "$site | Capturando par $site e gerando PDF =)"
		#xvfb-run wkhtmltopdf $link $site.pdf		#CAPTURA DO SITE DIRETO PARA O PDF, desculpa python, php.
		m "$site | Par $site encerrado"
	done < sites ;						# Chama o arquivo sites.txt para o laço.
		m "Terminando | Colocando em ordem e removendo duplicados do par no arquivo histórico e dados."
		sort $HOME/hist.csv | uniq > $HOME/historico.txt
		sort $HOME/dd.csv | uniq | sed "s/___/ /" > $HOME/dados.txt

}
cria_email(){ 							#Modelo de e-mail que será enviado
	m "Criando e-mail"
	e "-----------------------------" > c
	e "RELATORIO DE SITES ACESSADOS" >> c
	e "" >> c
	e "PAR--------DATA-----HORA----VALOR---VARIAÇÃO---%--->" >> c
	e "" >> c
	cat dados.txt >> c
	e "" >> c
	e "Acesse em:" >> c
	e "https://goo.gl/Kohpyc" >> c
	e "MrRobotTrade" >> c
	e "-----------------------------" >> c
}
envia_email(){
	grep -v "^#" $m > y
	while read z n WHATS; do 
		m "$z | Enviando e-mail"
		#mutt -s "$n - SEU RELATORIO TRADE DE $diaatual" $z < c -a *.pdf log.txt $HOME/dados.txt $HOME/historico.txt; done < y
		mutt -s "$n - SEU RELATORIO TRADE DE $diaatual" $z < c -a log.txt $HOME/dados.txt $HOME/historico.txt; done < y
		wget -q "https://api.telegram.org/bot654898957:AAFLCIG3P4t_DTg_GrlyqsVKnWKCvbrlFCA/sendMessage?chat_id=-157374761&text=Sua estatística até $diaatual está quentinha, confira aqui https://goo.gl/Kohpyc" -O "$site.html";
}
remove_temporarios(){ rm -rf c y *.pdf log.txt *.html sites dados.txt dados; m "SESSAO ENCERRADA, PODE VOLTAR A TOMAR CAFÉ";}
captura
cria_email
envia_email
remove_temporarios
