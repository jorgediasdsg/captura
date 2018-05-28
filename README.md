<h1>PROGRAMA PARA CAPTURA DE TELA E ENVIO DE EMAIL</h1>

<h3>O que ele faz?</h3>

<p>Ele captura a tela de uma lista de sites em txt.</p>

<p>Compacta os arquivos em um único arquivo</p>

<p>Envia para lista de e-mail o anexo zipado</p>

<h4>INSTALAÇÃO</h4>

<p>Copie e cole no terminal o código abaixo.</p>

<code>rm -rf $HOME/TRADE; mkdir $HOME/TRADE; cd $HOME/TRADE; git clone https://github.com/jorgediasdsg/email.git; git clone https://github.com/jorgediasdsg/captura.git; cd email; sudo chmod +x email.min.sh; ./email.min.sh; cd ..; cd captura; sudo chmod +x captura.min.sh; ./captura.min.sh; echo "ACESSE $HOME/TRADE/CAPTURA/emails,txt e $HOME/TRADE/CAPTURA/sites.txt, edite como quiser!" > welcome-borchardt.txt; gedit welcome-borchardt.txt</code>
