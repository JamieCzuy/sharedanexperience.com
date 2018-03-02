set -e
echo ""
echo "Dev Locally:"
echo ""

ENV_FILE="./env_files/local.env"
echo "  Sourcing env file (${ENV_FILE}):"
if [ ! -f ${ENV_FILE} ]; then
    echo "ERROR: Local env var file (${ENV_FILE}) not found!"
    exit -1
fi
source ${ENV_FILE}
echo "    Project Name: ${COMPOSE_PROJECT_NAME}"


read -p "  Run pip install (y/N): " -n 1 -r ; echo ""
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
    pip --quiet install -r django/requirements.txt
fi


echo ""
echo "Database"

CREATE_NEW="True"
DB_SERVER="${COMPOSE_PROJECT_NAME}_db_1"
if docker ps --filter Name=${DB_SERVER} | grep -q ${DB_SERVER}; then
    CREATE_NEW="False"
    read -p "  KILL existing (running) DB Server (${DB_SERVER}) (y/N): " -n 1 -r; echo ""
    if [[ ${REPLY} =~ ^[Yy]$ ]]; then
        docker kill ${DB_SERVER}
        read -p "  Remove the container (y/N): " -n 1 -r; echo ""
        if [[ ${REPLY} =~ ^[Yy]$ ]]; then
            docker rm ${DB_SERVER}
            CREATE_NEW="True"
        else
            read -p "  Restart the container (y/N): " -n 1 -r; echo ""
            if [[ ${REPLY} =~ ^[Yy]$ ]]; then
                docker start ${DB_SERVER}
            fi
        fi
    fi
fi

if [[ ${CREATE_NEW} == "True" ]]; then
    read -p "  Wipe local database folder (${DB_FOLDER}) (y/N): " -n 1 -r; echo ""
    if [[ ${REPLY} =~ ^[Yy]$ ]]; then
        [ -z "${DB_FOLDER}" ]  && echo "Env var DB_FOLDER needs to be set" && exit -1;
        rm -rf ${DB_FOLDER}
        mkdir ${DB_FOLDER}
    fi

    read -p "  Create new DB Server (docker-compose up -d db) (y/N): " -n 1 -r; echo ""
    if [[ ${REPLY} =~ ^[Yy]$ ]]; then
        [ -z "${DB_HOST}" ]  && echo "Env var DB_HOST needs to be set" && exit -1;
        [ -z "${DB_PORT}" ]  && echo "Env var DB_PORT needs to be set" && exit -1;
        docker-compose up -d db
        echo -n "  Waiting for DB Server to be ready ."
        until pg_isready --quiet --host=${DB_HOST} --port=${DB_PORT} -U postgres; do
            echo -n "."
            sleep 1
        done
        echo "Ready"
    fi

    read -p "  Create new Database (local) (y/N): " -n 1 -r; echo ""
    if [[ ${REPLY} =~ ^[Yy]$ ]]; then
        psql "${DATABASE_URL/\/local/postgres}" -c "create database local;"
    fi
fi


echo ""
echo "Migrations"

read -p "  Remove project's (sharedanexperience) migrations folder (y/N): " -n 1 -r ; echo ""
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
    rm -rf ./django/sharedanexperience/migrations
fi

read -p "  Remove people app's migrations folder (y/N): " -n 1 -r ; echo ""
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
    rm -rf ./django/people/migrations
fi

read -p "  Makemigrations (y/N): " -n 1 -r ; echo ""
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
    python django/manage.py makemigrations people
fi

read -p "  Migrate (y/N): " -n 1 -r ; echo ""
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
    python django/manage.py migrate
    echo ""
fi


echo ""
echo "Static Files"

read -p "  Remove staticfiles folder (y/N): " -n 1 -r ; echo ""
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
    rm -rf ./staticfiles
fi

read -p "  CollectStatic (y/N): " -n 1 -r ; echo ""
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
    python django/manage.py collectstatic --no-input -v 0
fi


echo ""
echo "Users:"
read -p "  Create superuser (dev_admin) (y/N): " -n 1 -r ; echo ""
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
    mkdir -p ./tmp
    TMPFILE="./tmp/make_dev_admin.py"
    [ -z "${DEV_ADMIN_NAME}" ]  && echo "Env var DEV_ADMIN_NAME needs to be set" && exit -1;
    [ -z "${DEV_ADMIN_EMAIL}" ] && echo "Env var DEV_ADMIN_EMAIL needs to be set" && exit -1;
    [ -z "${DEV_ADMIN_PW}" ]    && echo "Env var DEV_ADMIN_PW needs to be set" && exit -1;
    export DJANGO_SETTINGS_MODULE="sharedanexperience.settings"
    echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('$DEV_ADMIN_NAME', '$DEV_ADMIN_EMAIL', '$DEV_ADMIN_PW') " > $TMPFILE
    python django/manage.py shell < $TMPFILE
    rm $TMPFILE
fi

echo ""
echo "Run Server:"
if [ -z "${ADMIN_PORT}" ]; then
    ADMIN_PORT="8000"
fi
read -p "  Run Server on port ${ADMIN_PORT} (y/N): " -n 1 -r ; echo ""
if [[ ${REPLY} =~ ^[Yy]$ ]]; then
    python django/manage.py runserver ${ADMIN_PORT}
fi

echo ""
echo "Done"
