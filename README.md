# Go + MySQL — Docker Compose

This is the same Go application as `../local-app`, but Docker Compose runs both the application and MySQL.

## Services

- `app` — built from the local `Dockerfile` and published at <http://localhost:8080>
- `db` — MySQL 8.4 with data stored in the `mysql-data` named volume

The app connects to MySQL using the service name `db`. Compose provides both services with a shared network automatically.

## 1. Build and start both services

From this directory:

```bash
docker compose up --build -d
```

Check their state:

```bash
docker compose ps
docker compose logs app
docker compose logs db
```

Open <http://localhost:8080>. The page will initially show that no students exist.

## 2. Enter the MySQL container

```bash
docker compose exec db mysql -u courseuser -p course
```

Enter `coursepass` when prompted.

## 3. Add and view data

At the MySQL prompt:

```sql
INSERT INTO students (name, course)
VALUES ('Alice', 'DevOps'), ('Bob', 'Docker Compose');

SELECT * FROM students;
EXIT;
```

Refresh <http://localhost:8080> to see the records.

## 4. Inspect the running app

```bash
curl http://localhost:8080/health
docker compose logs -f app
docker compose exec app /bin/sh
```

Type `exit` to leave the app container.

## 5. Stop and restart

Stop and remove the containers and network:

```bash
docker compose down
```

Start them again:

```bash
docker compose up -d
```

Refresh the browser. The student records remain because MySQL uses a named volume.

## 6. Delete everything, including database data

The `-v` option permanently removes the named volume and its data:

```bash
docker compose down -v
```

The next `docker compose up` starts with an empty database.

## Useful commands

```bash
# Rebuild after changing Go code
docker compose up --build -d

# Show all service logs
docker compose logs

# Show Compose-created resources
docker compose ps
docker network ls
docker volume ls

# Run one SQL command without opening an interactive prompt
docker compose exec db mysql -u courseuser -pcoursepass course \
  -e "SELECT * FROM students;"
```

## Environment variables

The development credentials are stored in `.env` for this classroom exercise. Real passwords must not be committed to source control; production systems use a secrets manager or another secure secret mechanism.
# golang-sql-docker-
