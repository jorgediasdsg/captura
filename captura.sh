#!/bin/bash
#AUTOR JORGE DIAS jorgediasdsg@gmail.com https://github.com/jorgedsdsg/captura
cd $HOME/TRADE/captura
e(){ echo $1; } 							#Substitue echo por e
m(){ da=$(date +%d-%m-%Y-%X); echo $da \| $1; echo $da \| $1 >> log.txt; }
d=$(date +%d-%m-%Y-%X) 						#Captura a data do sistema para nomear os arquivos.
s=sites.txt  								#Chama o arquivos com sites.
m=emails.txt 								#Chama o arquivo com e-mails.
l=`pwd` 									#Localiza a pasta atual do sistema.
echo "LOG DE $d" > log.txt
captura(){
	grep -v "^#" $s > $l/sites 
	while read site link; do 				#Abre o laço de execução dos screenshots.
		d=$(date +%d-%m-%Y-%X)
		m "$site | Capturando do par de $link"		
		wget -q $link -O "$site.html"
		m "$site | Extraindo informações do par"
		valor=`cat "$site.html" | grep "last_last" | sed "s/<\/span>.*// ; s/.*>//"`
		variacao=`cat "$site.html" | grep "pc\" dir=\"ltr\"" | sed "s/<\/span>.*// ; s/.*\"ltr\">//"`
		porcentagem=`cat "$site.html" | grep "pcp parentheses\" dir=\"ltr\"" | sed "s/<\/span>.*// ; s/.*ltr\">//"`
		m "$site | Gravando par no arquivo"
		e "$site	$valor	$variacao	$porcentagem	$d	$link" >> $l/dados.txt
		e "" >> $l/dados.txt
		e "$site;	$valor;	$variacao;	$porcentagem;	$d;	$link;" >> $HOME/dd.csv
		m "$site | Extraindo histórico do par no arquivo"
		paste <(grep "data-real-valu" $site.html | sed "s/<\/td>.*// ; s/.*\">//" | sed "s/ var.*//" | xargs -n 5) <(grep "\<td\> class=\"bold" $site.html | sed 's/<\/td>.*/ '$site'/ ; s/.*\">/ /') >> $HOME/hist.csv
		m "$site | Colocando em ordem e removendo duplicados do par no arquivo"
		sort $HOME/hist.csv | uniq > $HOME/historico.txt
		sort $HOME/dd.csv | uniq > $HOME/dados.txt
		m "$site | Capturando par $site e gerando PDF =)"
		wkhtmltopdf $link $l/$site.pdf		#CAPTURA DO SITE DIRETO PARA O PDF, desculpa python, php.
		m "$site | Par $site encerrado"
	done < $l/sites 						# Chama o arquivo sites.txt para o laço.

}
cria_email(){ 							#Modelo de e-mail que será enviado
	m "Criando e-mail"
	e "-----------------------------" > $l/c
	e "RELATORIO DE SITES ACESSADOS" >> $l/c
	e "" >> $l/c
	e "PAR----VALOR--VARIAÇÃO---%-----------DATA---------LINK--------->" >> $l/c
	e "" >> $l/c
	cat dados.txt >> $l/c
	e "" >> $l/c
	e "ATT NELSON BORCHARDT" >> $l/c
	e "-----------------------------" >> $l/c
}
envia_email(){
	grep -v "^#" $m > $l/y
	while read z n WHATS; do 
		m "$z | Enviando e-mail para"
		mutt -s "$n - SEU RELATORIO TRADE DE $d" $z < c -a $l/*.pdf $l/log.txt $HOME/dados.csv $HOME/historico.csv; done < $l/y
}
remove_temporarios(){ rm -rf $l/c $l/y $l/*.pdf $l/log.txt $l/*.html $l/sites $l/dados $l/dados.txt; m "SESSAO ENCERRADA, PODE VOLTAR A TOMAR CAFÉ"; }
captura
cria_email
envia_email
remove_temporarios
