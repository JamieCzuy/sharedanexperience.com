echo "Dev Locally:"
echo "Runserver locally (with auto-reloading) using dockerd database (using local folder)"

echo "Sourcing local.env file"
source ./env_files/local.env

echo "Starting dockered database"
echo "    DATABASE_URL: ${DATABASE_URL}"
docker-compose up -d db
until psql ${DATABASE_URL} -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 3
done

echo "Making Migrations (just in case)"
echo "  For:"
echo "      The Project:"
python django/manage.py makemigrations
for APP in 'people'; do
    echo "      The ${APP} App:"
    python django/manage.py makemigrations ${APP}
done

echo "Migrate (just in case)"
python django/manage.py migrate

if [ -z "${PORT}" ]; then
    PORT=8000
fi
echo ""
echo "Running server (on ${PORT})"
echo ""
python django/manage.py runserver ${PORT}

echo ""
echo ""
echo "Done: Running Server locally"
echo ""
read -p "Dockered Database is still running: kill it (y/N): " -n 1 -r
echo ""
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
    echo "    Stopping and removing dockered db"
    docker-compose rm --force --stop db
fi
echo "Done"
