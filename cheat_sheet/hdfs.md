# HDFS (Hadoop Distributed File System)
- O HDFS é o sistema de arquivos distribuído do Hadoop, projetado para armazenar grandes volumes de dados de forma confiável e eficiente em clusters de computadores.
- Ele divide os arquivos em blocos e os distribui por vários nós do cluster, garantindo alta disponibilidade e tolerância a falhas.

# Comandos para usar o HDFS no terminal

## Listar arquivos e diretórios

    - hdfs dfs -ls / 
    - hdfs dfs -ls /user/hadoop
    - hdfs dfs -ls -R /user/hadoop {recursivo}
    - hdfs dfs -ls -h /user/hadoop {tamanho legível}
    - hdfs dfs -ls -d /user/hadoop/* {listar apenas diretórios}
    - hdfs dfs -ls -t /user/hadoop {ordenar por data}
    - hdfs dfs -ls -S /user/hadoop {ordenar por tamanho}

## Criar diretórios

    - hdfs dfs -mkdir /user/hadoop/novo_diretorio
    - hdfs dfs -mkdir -p /user/hadoop/novo_diretorio/subdiretorio {criar diretórios pai se não existirem}
    - hdfs dfs -mkdir -v /user/hadoop/novo_diretorio {mostrar detalhes da criação}
    - hdfs dfs -mkdir -m 755 /user/hadoop/novo_diretorio {definir permissões}

## Criar um arquivo 

    1. Criamos primeiro o arquivo localmente, no nosso caso no container linux, e depois copiamos para o HDFS.
    
    - echo "Conteúdo do arquivo" > arquivo_local.txt
      -> aqui ele cria um arquivo local chamado "arquivo_local.txt" com o conteúdo "Conteúdo do arquivo".

    - hdfs dfs -put arquivo_local.txt /user/hadoop/arquivo_no_hdfs.txt
      -> aqui ele copia o arquivo local "arquivo_local.txt" para o HDFS, criando um arquivo chamado "arquivo_no_hdfs.txt" no diretório "/user/hadoop/".

    - hdfs dfs -cat /user/hadoop/arquivo_no_hdfs.txt
      -> aqui ele exibe o conteúdo do arquivo "arquivo_no_hdfs.txt" que está no HDFS, mostrando "Conteúdo do arquivo" no terminal.

    - hdfs dfs -copyFromLocal arquivo_local.txt /user/hadoop/arquivo_no_hdfs.txt
      -> outra forma de copiar um arquivo local para o HDFS, equivalente ao comando "put".

    - hdfs dfs -copyToLocal /user/hadoop/arquivo_no_hdfs.txt arquivo_local_copiado.txt
        -> aqui ele copia o arquivo do HDFS de volta para o sistema local, criando um arquivo chamado "arquivo_local_copiado.txt" com o mesmo conteúdo.

    -> caso queira adicionar mais conteudo a um arquivo já existente no HDFS, você pode usar o comando "appendToFile":
    - echo "Mais conteúdo" >> arquivo_local.txt
      -> aqui ele adiciona "Mais conteúdo" ao final do arquivo local "arquivo_local.txt".

    - hdfs dfs -appendToFile arquivo_local.txt /user/hadoop/arquivo_no_hdfs.txt
      -> aqui ele pega o conteúdo atualizado do arquivo local e adiciona ao final do arquivo no HDFS, então o arquivo "arquivo_no_hdfs.txt" agora terá:
      ```
        Conteúdo do arquivo
        Mais conteúdo
      ```

    - hdfs dfs -cat /user/hadoop/arquivo_no_hdfs.txt
      -> aqui ele exibe o conteúdo atualizado do arquivo no HDFS, mostrando:
      ```
        Conteúdo do arquivo
        Mais conteúdo
      ```
## Remover arquivos e diretórios

    - hdfs dfs -rm /caminho/do/arquivo_no_hdfs.txt
      -> aqui ele remove o arquivo "arquivo_no_hdfs.txt" do HDFS.

    - hdfs dfs -rm -r /caminho/do/novo_diretorio
      -> aqui ele remove o diretório "novo_diretorio" e todo o seu conteúdo do HDFS.

    - hdfs dfs -rm -skipTrash /caminho/do/arquivo_no_hdfs.txt
      -> aqui ele remove o arquivo do HDFS sem enviá-lo para a lixeira, ou seja, ele será excluído permanentemente.
    
# verificar status do sistema de arquivos (health check)

    -hdfs fsck / -files -blocks -locations
      -> aqui ele verifica a integridade do sistema de arquivos HDFS, listando os arquivos, blocos, e suas localizações nos DataNodes. Isso é útil para identificar arquivos corrompidos ou problemas de replicação.


## Administrar o HDFS

    -hdfs dfsadmin -setQuota 5 /diretorio
      -> aqui ele define uma cota de 5 arquivos para o diretório especificado, limitando o número de arquivos que podem ser criados nesse diretório. {pode limitar a quantidade que achar desejável}

    - hdfs dfsadmin -report
      -> aqui ele exibe um relatório detalhado sobre o estado do HDFS, incluindo informações sobre os DataNodes, espaço disponível, arquivos armazenados, e status geral do sistema de arquivos.

    - hdfs dfsadmin -safemode get
      -> aqui ele verifica se o HDFS está em modo de segurança (safemode), que é um estado em que o sistema de arquivos é somente leitura para proteger os dados durante a inicialização ou manutenção.

    - hdfs dfsadmin -safemode enter
      -> aqui ele coloca o HDFS em modo de segurança, tornando-o somente leitura. Isso pode ser útil para realizar manutenção ou proteger os dados durante uma falha.

    - hdfs dfsadmin -safemode leave
      -> aqui ele tira o HDFS do modo de segurança, permitindo que ele volte a ser leitura e escrita normalmente.

    - hdfs dfsadmin -refreshNodes
      -> aqui ele força o NameNode a atualizar a lista de DataNodes ativos, o que pode ser útil após adicionar ou remover DataNodes do cluster.

    - hdfs dfsadmin -refreshServiceAcl
      -> aqui ele atualiza as ACLs (Access Control Lists) dos serviços do Hadoop, garantindo que as permissões estejam corretas após alterações nas configurações de segurança.