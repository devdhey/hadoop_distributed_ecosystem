# Hive Server2 Cheat Sheet

Dicas e comandos para gerenciar e verificar o estado do Hive Server2.

## Verificar Estado do Serviço

### Logs do Container
```bash
docker logs -f hive-server
```

### Verificar canais de escuta (Portas)
O Hive Server2 geralmente escuta nas portas **10000** (Thrift) e **10002** (WebUI).
```bash
docker exec -it hive-server netstat -tuln | grep -E "10000|10002"
```

### Healthcheck Manual
```bash
docker inspect --format='{{json .State.Health}}' hive-server
```

## Conectar ao Hive (Beeline)

### Conexão Interna (dentro do container)
```bash
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000
```

### Conexão Externa (do Host)
Certifique-se de que a porta 10000 está mapeada no `docker-compose.yml`.
```bash
beeline -u jdbc:hive2://localhost:10000 -n hive -p hive
```

## Comandos Úteis no Beeline

```sql
-- Listar databases
SHOW DATABASES;

-- Listar tabelas
SHOW TABLES;

-- Verificar funções disponíveis
SHOW FUNCTIONS;

-- Verificar configurações atuais
SET;
```

## Solução de Problemas

- **Erro de Memória:** Se o HiveServer2 cair frequentemente, verifique o `HADOOP_CLIENT_OPTS` no `hadoop.env`.
- **Zombies/Locks:** Se o serviço não iniciar por causa de um PID antigo, verifique `/tmp/hive` dentro do container.
