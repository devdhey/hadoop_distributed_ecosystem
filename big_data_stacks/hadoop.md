# 🐘 Guia Completo do Ecossistema Hadoop

Bem-vindo ao guia definitivo sobre o Apache Hadoop. Este documento foi projetado tanto para iniciantes que estão dando os primeiros passos no mundo do Big Data quanto para usuários avançados que precisam de uma referência técnica sólida.

---

## 1. O que é o Hadoop?

Em termos simples, o Hadoop é uma plataforma de software de código aberto que permite o **armazenamento** e o **processamento** de grandes volumes de dados (Big Data) de forma distribuída em clusters de computadores.

### A Filosofia do Hadoop:
*   **Escalabilidade Horizontal:** Em vez de comprar um supercomputador caro, você adiciona servidores comuns ao cluster.
*   **Tolerância a Falhas:** O Hadoop assume que o hardware vai falhar e cria réplicas dos dados automaticamente.
*   **Levar o Processamento ao Dado:** Em vez de mover TBs de dados pela rede, o Hadoop envia o código para onde o dado já está armazenado.

---

## 2. Estrutura e Componentes Core

O Hadoop é dividido em três camadas principais:

### 📂 HDFS (Hadoop Distributed File System) - Armazenamento
É o sistema de arquivos distribuído. Imagine um disco rígido gigante que, na verdade, é composto por vários discos de máquinas diferentes.

*   **NameNode (O Mestre):**
    *   **Função:** Mantém o "mapa" de onde cada pedaço de arquivo está. Gerencia os metadados (nomes de arquivos, permissões, localização dos blocos).
    *   **No seu projeto:** Configurado em `core-site.xml` como `hdfs://namenode:8020`.
    *   - Por padrão o namenode tem o safemode ativo, que em ambientes gigantescos é muito bom para evitar corrupção de dados generalizada
    *   - Em produção nunca force a saída do Safe mode -> ```docker exec -it namenode hdfs dfsadmin -safemode leave```
    *   - Para reativar o SafeMode -> ```docker exec -it namenode hdfs dfsadmin -safemode enter```
    *   - Se esquece o estado atual do SafeMode -> ```docker exec -it namenode hdfs dfsadmin -safemode get```
*   **DataNode (O Escravo/Trabalhador):**
    *   **Função:** Armazena os dados reais em blocos. Executa operações de leitura e escrita a pedido dos clientes e do NameNode.
    *   **No seu projeto:** Você possui `datanode1` e `datanode2` listados no arquivo `workers`.

#### Exemplo de Configuração (HDFS):
No seu arquivo `hdfs-site.xml`, vemos a configuração de replicação:
```xml
<property>
  <name>dfs.replication</name>
  <value>2</value> <!-- Garante que cada bloco tenha 1 original e 1 cópia -->
</property>
```

---

### ⚖️ YARN (Yet Another Resource Negotiator) - Gerenciamento
É o "sistema operacional" do Hadoop. Ele decide quem ganha memória e CPU no cluster.

*   **ResourceManager (RM):**
    *   **Função:** O árbitro central. Ele decide como os recursos do cluster são distribuídos entre as aplicações.
*   **NodeManager (NM):**
    *   **Função:** O agente em cada máquina. Ele monitora o uso de recursos (CPU, Memória) no nó e reporta ao ResourceManager.

#### Gerenciamento de Memória no seu Projeto:
Em `yarn-site.xml`, você definiu limites estritos para evitar que o cluster trave:
```xml
<property>
  <name>yarn.nodemanager.resource.memory-mb</name>
  <value>2048</value> <!-- Cada servidor contribui com 2GB de RAM -->
</property>
<property>
  <name>yarn.scheduler.maximum-allocation-mb</name>
  <value>1024</value> <!-- Nenhuma tarefa individual pode pedir mais de 1GB -->
</property>
```

---

### ⚙️ MapReduce - Processamento
É o modelo de programação para processar dados em paralelo.

1.  **Map (Mapeamento):** Filtra e classifica os dados (ex: contar palavras em uma página).
2.  **Reduce (Redução):** Resume os resultados do Map (ex: somar as contagens totais).

#### Configuração de Memória MapReduce:
Visto em seu `mapred-site.xml`:
```xml
<property>
  <name>mapreduce.map.memory.mb</name>
  <value>800</value> <!-- Cada tarefa Map usa 800MB -->
</property>
<property>
  <name>mapreduce.map.java.opts</name>
  <value>-Xmx640m</value> <!-- O Java usa 640MB (80% da alocação) para segurança -->
</property>
```

---

## 3. Fluxo de Trabalho (Como tudo se integra)

1.  O **Cliente** envia um arquivo para o **HDFS**.
2.  O **NameNode** divide o arquivo em blocos e diz aos **DataNodes** para guardá-los (respeitando a replicação=2).
3.  O **Cliente** envia um código **MapReduce**.
4.  O **ResourceManager (YARN)** encontra espaço nos **NodeManagers**.
5.  O código é executado localmente nos **DataNodes** onde os dados estão.
6.  O resultado final é salvo de volta no **HDFS**.

---

## 4. Guia Prático de Comandos (CLI)

Para estudantes que querem começar a operar o cluster:

### Manipulando Arquivos (HDFS):
```bash
# Listar arquivos na raiz
hdfs dfs -ls /

# Criar um diretório
hdfs dfs -mkdir -p /user/estudante/input

# Upload de um arquivo local para o cluster
hdfs dfs -put meu_arquivo.txt /user/estudante/input/

# Ler um arquivo do cluster
hdfs dfs -cat /user/estudante/input/meu_arquivo.txt

#Vale ressaltar que caso esteja rodando tudo em ambiente docker, o arquivo de upload deve estar presente no container do namenode, ou seja, o caminho do arquivo deve ser o caminho dentro do container.
# um exeplo de criação de arquivo dentro do container do namenode:
docker exec -it namenode bash
echo "Conteúdo do meu arquivo" > /tmp/meu_arquivo.txt
hdfs dfs -put /tmp/meu_arquivo.txt /user/estudante/input/ #ou CopyToHDFS /tmp/meu_arquivo.txt /user/estudante/input/
```

### Monitorando o Cluster (YARN):
```bash
# Listar aplicações rodando
yarn application -list

# Matar uma aplicação específica
yarn application -kill <application_ID>
```

---

## 5. Dicas Avançadas para Desenvolvedores

*   **Data Locality:** Sempre tente rodar o processamento no mesmo nó do dado. O YARN tenta fazer isso automaticamente.
*   **Virtual Memory Check:** No seu projeto, a verificação de memória virtual está desativada (`yarn.nodemanager.vmem-check-enabled = false`). Isso é crucial ao rodar Hadoop dentro de **Docker** ou **WSL2**, pois esses ambientes gerenciam a memória de forma diferente do Linux nativo.
*   **Speculative Execution:** Se uma tarefa está demorando muito em um nó "lento", o Hadoop pode iniciar uma cópia idêntica em outro nó e usar o resultado da que terminar primeiro.

---

> [!TIP]
> **Dica de Ouro:** O Hadoop não foi feito para "milhares de arquivos pequenos". Ele prefere "poucos arquivos gigantes". Muitos arquivos pequenos sobrecarregam a memória do NameNode com metadados!
> Para contornar isso, podemos usar o comando `hadoop fs -getmerge` para combinar arquivos pequenos em um único arquivo grande antes de processar.
> Como é um ambiente de estudo, é interessante criar arquivos pequenos para entender o comportamento do Hadoop, mas em produção, é recomendado usar arquivos grandes para otimizar o desempenho.
