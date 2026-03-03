# Explorando o YARN (Yet Another Resource Negotiator)
- O YARN é o sistema de gerenciamento de recursos do Hadoop, responsável por alocar recursos (CPU, memória) para as aplicações que rodam no cluster.
- O gerente 

## Comandos YARN

# Listar e Filtrar 

    - yarn application -list
    - yarn application -list -appStates ALL {filtrar por estado como : RUNNING, ACCEPTED, FINISHED, etc}
    - yarn application -list -appTypes MAPREDUCE
    - yarn application -list -appTypes SPARK
    - yarn application -list -appTypes HIVE 
    
# Ver o Status detalhado de um nó específico
    - yarn node -status <NodeID> {ex: yarn node -status datanode1:8040}
    - yarn node -list
    - yarn node -list -all {listar todos os nós, incluindo os que estão inativos}
    - yarn node -list -state RUNNING {listar apenas os nós que estão ativos e rodando aplicações}
    - 
# Consultar Logs (pós-morte)
    - yarn logs -applicationId aplication_1772474633150_0001 {pegar os logs de uma aplicação específica usando seu ID}
    {No dia a dia, o erro raramente aparece no seu terminal; ele fica escondido nesses logs do YARN.}

# Consultar Logs (em tempo real)
    - yarn logs -applicationId aplication_1772474633150_0001 -follow {seguir os logs em tempo real, útil para debugging enquanto a aplicação está rodando}