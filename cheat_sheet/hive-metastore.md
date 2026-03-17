# Hive Metastore Cheat Sheet

Dicas e comandos para gerenciar e verificar o estado do Hive Metastore.

## Verificar Estado do Serviço

### Logs do Container
```bash
docker logs -f hive-metastore
```

### Verificar Porta do Metastore
O Metastore geralmente escuta na porta **9083**.
```bash
docker exec -it hive-metastore nc -z localhost 9083
```

### Verificar Conexão com o Postgres
O Metastore depende do `hive-postgres`. Verifique se ele consegue alcançar o banco:
```bash
docker exec -it hive-metastore ping hive-postgres
```

## Manutenção do Schema

Se precisar inicializar ou atualizar o schema do Metastore manualmente (embora o container geralmente faça isso):

```bash
docker exec -it hive-metastore schematool -dbType postgres -info
```

## Verificação de Integridade

### Verificar HDFS Connection
O Metastore precisa se comunicar com o NameNode para gerenciar metadados de tabelas externas/internas.
```bash
docker exec -it hive-metastore hdfs dfsadmin -report
```

## Dicas

- **Timeout na Inicialização:** O Metastore pode demorar para subir se o Postgres estiver inicializando. Verifique o Healthcheck no `docker-compose.yml`.
- **Drivers:** O driver JDBC do Postgres deve estar em `/opt/hive/lib/`.
