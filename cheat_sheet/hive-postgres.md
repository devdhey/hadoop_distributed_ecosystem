# Hive Postgres Cheat Sheet

Dicas e comandos para gerenciar o banco de dados do Metastore do Hive.

## Acesso ao Banco de Dados

### Entrar no CLI do Postgres (psql)
```bash
docker exec -it hive-postgres psql -U hive -d metastore
```

## Comandos Úteis (SQL)

### Listar Tabelas do Metastore
```sql
\dt
```

### Verificar Versão do Schema do Metastore
```sql
SELECT * FROM "VERSION";
```

### Listar Databases Criadas no Hive
```sql
SELECT "NAME", "DB_LOCATION_URI" FROM "DBS";
```

### Listar Tabelas e seus Tipos
```sql
SELECT "TBL_NAME", "TBL_TYPE" FROM "TBLS";
```

## Monitoramento

### Verificar Conexões Ativas
```sql
SELECT count(*) FROM pg_stat_activity;
```

### Healthcheck Manual
```bash
docker exec -it hive-postgres pg_isready -U hive -d metastore
```

## Dicas

- **Backup do Metastore:** Recomenda-se fazer dump periódico das tabelas de metadados.
- **Configuração:** O Postgres deve estar com `password_encryption=md5` para compatibilidade com versões mais antigas do Hive.
