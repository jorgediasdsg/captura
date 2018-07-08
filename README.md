<h1>PROGRAMA PARA CAPTURA DE TELA E ENVIO DE EMAIL</h1>

<h3>O que ele faz?</h3>

<p>Ele captura a tela de uma lista de sites em txt.</p>

<p>Compacta os arquivos em um único arquivo</p>

<p>Envia para lista de e-mail o anexo zipado</p>

<h3>Como ele faz isso?</h3>

<p>Baixa 2 projetos do GIT</p>

<a href="https://github.com/jorgediasdsg/email.git">CLIENTE DE EMAIL</a>

<a href="https://github.com/jorgediasdsg/captura.git">CAPTURA DE TELA</a>

<p>Cria a pasta £HOME/TRADE</p>

<p>Instala os arquivos .sh</p>

<p>Roda a primeira vez para teste.</p>

<h3>Como editar para minha lista de sites e emails.</h3>

<p>Edite o arquivo sites.txt, e emails.txt.</p>

<p>Use o comando abaixo e siga o modelo que está no arquivo.</p>

<code>sudo nano $HOME/TRADE/captura/sites.txt</code>

<code>sudo nano $HOME/TRADE/captura/emails.txt</code>

<h4>INSTALAÇÃO</h4>

<p>Adicione na cron o agendamento com 2 linhas conforme abaixo, uma para abrir o chrome outra para rodar o script.</p>

<p>Endereço</p>
<code>sudo nano /etc/crontab</code>

<p>Copie, edite e cole as linhas abaixo</p>

<code>00 03 * * * meuhostname env DISPLAY=:0  bash -c "google-chrome-stable"</code>

<code>01 03 * * * meuhostname env DISPLAY=:0 bash $HOME/TRADE/captura/captura.min.sh</code>


<p>Copie e cole no terminal o código abaixo.</p>

<code>sudo apt-get install wkhtmltopdf -y;sudo apt-get install git -y;rm -rf $HOME/TRADE;mkdir $HOME/TRADE; cd $HOME/TRADE; git clone https://github.com/jorgediasdsg/email.git;git clone https://github.com/jorgediasdsg/captura.git;cd email;sudo chmod +x email.min.sh;./email.min.sh;cd ..;cd captura; cp start.sh $HOME/start.sh;sudo chmod +x $HOME/start.sh;/bin/bash ./start.sh;</code>
