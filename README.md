# Sincronizador de Backup

* Script utilizado para realizar o upload de backups do Fileserver para um bucket na Backblaze.*

  - Nome do cliente é passado como argumento na execução;
  - Define pasta de origem e destino, baseado no nome do cliente;
  - Compacta a pasta origem com 7zip, incluíndo timestamp no nome do arquivo;
  - Verifica se a pasta destino já existe, senão ela é criada;
  - Upload do arquivo compactado utilizando o rclone;
  - Exclusão do arquivo compactado no local de origem.

* Script é executado pelo agendador do Windows dentro de uma janela específica para cada cliente.
