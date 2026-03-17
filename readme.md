# Hadoop Cluster com Docker 

Este projeto implementa um cluster Apache Hadoop 3.3.6 funcional utilizando Docker Compose.  
A arquitetura foi projetada para separar claramente as camadas de armazenamento (HDFS) e gerenciamento de recursos (YARN), permitindo estudo prático de sistemas distribuídos e futura integração com ferramentas de processamento e orquestração de dados.

Este ambiente faz parte de um laboratório de engenharia de dados voltado ao estudo de pipelines distribuídos, armazenamento escalável e processamento paralelo.

---

## Arquitetura do Cluster

O cluster é composto por três camadas principais.

### HDFS — Camada de Armazenamento

- **NameNode**  
  Responsável pelos metadados do sistema de arquivos distribuído.

- **DataNode 1 e DataNode 2**  
  Responsáveis pelo armazenamento real dos blocos de dados.  
  Fator de replicação configurado: 2.

### YARN — Camada de Processamento

- **ResourceManager**  
  Gerencia recursos computacionais e coordena a execução de jobs.

- **NodeManager 1 e NodeManager 2**  
  Executam tarefas distribuídas em cada nó do cluster.

### Hive — Camada de SQL / Data Warehouse

- **Hive Server2**  
  Interface para execução de consultas SQL (HQL) via JDBC/Thrift.

- **Hive Metastore**  
  Gerencia o catálogo de metadados das tabelas do Hive.

- **Hive Postgres**  
  Banco de dados relacional que armazena os metadados do Metastore.

---

## Estrutura de Arquivos

Certifique-se de que a estrutura do projeto esteja organizada da seguinte forma:

.
├── docker-compose.yml
├── hadoop/
│   └── hadoop-config/
│       ├── core-site.xml
│       ├── hdfs-site.xml
│       ├── yarn-site.xml
│       └── hadoop.env
└── hive/
    └── hive-config/
        ├── hive-site.xml
        ├── tez-site.xml
        └── hive.env


---

## Como Executar

### 1. Configuração de Ambiente
Antes de rodar o cluster, configure seus arquivos de ambiente:
```bash
cp hadoop/hadoop-config/hadoop.env.example library/hadoop-config/hadoop.env
cp hive/hive-config/hive.env.example hive/hive-config/hive.env
```

### 2. Iniciar o Cluster

No diretório raiz do projeto, execute:
```bash
docker-compose up -d
```

---

## Interfaces Web

O cluster fornece interfaces gráficas para monitoramento operacional.

| Serviço | URL | Descrição |
|---|---|---|
| HDFS NameNode | http://localhost:9870 | Status do sistema de arquivos |
| YARN ResourceManager | http://localhost:8383 | Monitoramento de jobs e recursos |
| Hive Server2 UI | http://localhost:10002 | Interface Web do Hive Server |

---

## Ajuda e Comandos (Cheat Sheets)

Para auxiliar na construção e verificação do projeto, foram criados arquivos de dicas (Cheat Sheets):

- [Hive Server2](cheat_sheet/hive-server2.md)
- [Hive Metastore](cheat_sheet/hive-metastore.md)
- [Hive Postgres](cheat_sheet/hive-postgres.md)

---

## Objetivo do Projeto

Este cluster foi projetado como ambiente de laboratório para:

- Estudo de arquitetura distribuída
- Compreensão do funcionamento interno do HDFS
- Execução de processamento distribuído com YARN e Hive
- Base para integração futura com ferramentas de engenharia de dados (Spark, Airflow)

---

## Próxima Fase

### Fase 3 — Processamento Distribuído com Spark

A próxima etapa incluirá:
- Integração do Apache Spark com o Hive Metastore
- Execução de jobs Spark em modo YARN
- Pipelines de processamento in-memory

