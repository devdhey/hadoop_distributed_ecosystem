# 🐝 Guia Completo do Apache Hive

O Apache Hive é uma infraestrutura de **Data Warehouse** construída sobre o ecossistema Hadoop. Ele permite que desenvolvedores e analistas consultem e gerenciem grandes conjuntos de dados armazenados em sistemas de arquivos distribuídos (como HDFS) usando uma linguagem muito semelhante ao SQL tradicional, chamada **HiveQL (HQL)**.

---

## 1. O que é o Apache Hive?

Em resumo, o Hive é uma ferramenta de **abstração**. Ele transforma consultas SQL em tarefas complexas de processamento distribuído (originalmente MapReduce, mas também Spark ou Tez), permitindo que qualquer pessoa que conheça SQL possa interagir com o Big Data sem precisar escrever código Java ou Python complexo.

### O papel do Hive no Ecossistema:
*   **Schema on Read:** Ao contrário dos bancos de dados relacionais (que validam o esquema na inserção), o Hive aplica a estrutura (esquema) no momento da leitura do dado.
*   **Abstração de Armazenamento:** Ele não armazena os dados "dentro" de si; ele gerencia metadados que descrevem onde e como os arquivos estão organizados no HDFS.

---

## 2. Por que ele complementa o Hadoop Common?

O Hadoop Common fornece as bibliotecas e utilitários básicos, enquanto o HDFS cuida do armazenamento e o MapReduce do processamento. O Hive entra como a **camada de inteligência e interface**:

1.  **Produtividade:** Escrever 10 linhas de HQL é muito mais rápido do que escrever centenas de linhas de MapReduce em Java.
2.  **Acesso Democrático:** Permite que equipes de Business Intelligence (BI) e Analistas de Dados utilizem o cluster Hadoop sem treinamento profundo em engenharia de software.
3.  **Metastore Centralizada:** O Hive cria um catálogo (Metastore) que outros softwares do ecossistema (como Impala, Presto ou Spark SQL) podem consultar para entender a estrutura dos dados.

---

## 3. Principais Características

*   **HiveQL (HQL):** Linguagem de consulta tipo SQL.
*   **Particionamento (Partitioning):** Divide tabelas em pastas baseadas em colunas (ex: `/ano=2024/mes=03/`), acelerando drasticamente as consultas ao evitar o scan de dados irrelevantes.
*   **Bucketing (Clustering):** Divide os dados dentro das partições em arquivos menores (buckets) baseados em um hash de uma coluna, otimizando *joins* e amostragens.
*   **Suporte a Diversos Formatos:** Trabalha nativamente com arquivos de texto (CSV, TSV), mas brilha com formatos colunares como **Parquet** e **ORC**.
*   **UDFs (User Defined Functions):** Se o SQL padrão não for suficiente, você pode escrever funções customizadas em Java ou Python.

---

## 4. Dicas de Configuração (Checklist)

Para um ambiente saudável (especialmente em Docker/WSL), observe:

*   **Hive Metastore (HMS):** Configure um banco de dados externo (como MySQL ou PostgreSQL) para os metadados. Evite o Derby padrão em produção, pois ele não suporta múltiplas conexões.
*   **Execução Spark/Tez:** No seu arquivo `hive-site.xml`, tente definir `hive.execution.engine` como `tez` ou `spark` para performance superior ao MapReduce.
*   **Vem Check:** Assim como no YARN, desative a verificação de memória virtual se encontrar erros de "Limit Exceeded" em containers:
    ```xml
    <property>
      <name>hive.metastore.try.direct.sql</name>
      <value>true</value>
    </property>
    ```
*   **Warehouse Directory:** Defina o local padrão no HDFS:
    `hive.metastore.warehouse.dir = /user/hive/warehouse`

---

## 5. Exemplos de Código (HQL)

### Criando Tabelas (Managed vs External)

```sql
-- TABELA EXTERNA: Se você deletar a tabela no Hive, os arquivos NO HDFS permanecem.
-- Recomendado para dados compartilhados entre ferramentas.
CREATE EXTERNAL TABLE IF NOT EXISTS vendas_brutas (
    id_venda INT,
    produto STRING,
    valor DOUBLE,
    data_venda STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/data/vendas/';

-- TABELA GERENCIADA (MANAGED): O Hive controla o ciclo de vida. Deletar a tabela apaga os dados.
CREATE TABLE logs_acesso (
    usuario STRING,
    ip STRING,
    timestamp BIGINT
)
PARTITIONED BY (dia STRING)
STORED AS ORC;
```

### Carregando e Consultando

```sql
-- Carregar dados de um arquivo local para o Hive
LOAD DATA LOCAL INPATH '/tmp/vendas.csv' INTO TABLE vendas_brutas;

-- Consulta com agregação
SELECT produto, SUM(valor) as total
FROM vendas_brutas
GROUP BY produto
HAVING total > 1000;
```

---

## 6. Boas Práticas (Guia de Sobrevivência)

1.  **Sempre Particione:** Nunca crie uma tabela grande sem partição. Use colunas de data ou região.
2.  **Use Formatos Colunares:** Em produção, converta seus dados de `TEXTFILE` para `ORC` ou `Parquet`. Eles ocupam menos espaço e são muito mais rápidos para leitura.
3.  **Evite Joins em Tabelas Gigantes sem Partição:** Tente filtrar os dados o máximo possível no `WHERE` antes de realizar o `JOIN`.
4.  **Cuidado com "Many Small Files":** Assim como o Hadoop, o Hive sofre com muitos arquivos pequenos. Use `ALTER TABLE ... CONCATENATE` em tabelas ORC para mesclar arquivos pequenos.
5.  **Vetorização:** Habilite o processamento vetorial para processar blocos de 1024 linhas por vez em vez de uma por uma:
    `set hive.vectorized.execution.enabled = true;`

---

> [!IMPORTANT]
> **Hive vs Banco SQL Comum:** Lembre-se que o Hive é feito para **Batch Processing** de Petabytes. Ele tem uma latência alta (segundos ou minutos para começar uma query). Se você precisa de respostas em milissegundos para um site, use um banco como PostgreSQL ou Redis, não o Hive!
