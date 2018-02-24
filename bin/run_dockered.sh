echo "Run Dockered:"
echo "Run both server and database in docker containers (using local folders)"

echo "Sourcing dockered.env file"
source ./env_files/dockered.env

echo "Starting dockered database"
echo "    DATABASE_URL: ${DATABASE_URL}"
docker-compose up -d db
sleep 5

# until psql ${DATABASE_URL} -c '\q'; do
#   >&2 echo "Postgres is unavailable - sleeping"
#   sleep 3
# done

echo "Making Migrations (just in case)"
echo "  For:"
echo "      The Project:"
docker-compose run --rm web python manage.py makemigrations
for APP in 'people'; do
    echo "      The ${APP} App:"
    docker-compose run --rm web python manage.py makemigrations ${APP}
done

echo "Migrate (just in case)"
docker-compose run --rm web python manage.py migrate

if [ -z "${PORT}" ]; then
    PORT=8000
fi
echo ""
echo "Building and Running server in docker copntainer"
echo ""
docker-compose up -d web

echo ""
echo "Watching the logs"
echo ""
docker-compose logs -f

echo ""
echo ""
echo "Done: Running Dockered Server"
echo ""
read -p "Dockered Server and Database are still running: kill them (y/N): " -n 1 -r
echo ""
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
    echo "    Stopping and removing dockered web"
    docker-compose rm --force --stop web
    echo "    Stopping and removing dockered db"
    docker-compose rm --force --stop db
fi
echo "Done"
