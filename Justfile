no_output := "> /dev/null 2>&1"

compose-down-all:
    @echo "Try to remove the production compose cluster..."
    @-just compose-down-prd {{no_output}}
    @echo "Try to remove the development compose cluster..."
    @-just compose-down-dev {{no_output}}
    @echo "Try to remove the testing compose cluster..."
    @-just compose-down-test {{no_output}}

### DEVELOPMENT ###

# Relative to the Justfile
containerfile_path_dev := "./api/Containerfile.dev"
# Relative to the Justfile
compose_file_path_dev := "compose.dev.yml" 
api_image_name_dev := "phoenix_api:dev"
api_container_name_dev := "time_manager_phoenix_api_dev"

webapp_containerfile_path_dev := "./webapp/Containerfile.dev"
webapp_image_name_dev := "vue_webapp:dev" 
webapp_container_name_dev := "time_manager_vue_webapp_dev"


compose-down-dev:
    -docker compose --file {{compose_file_path_dev}} down {{no_output}}
    -docker image rm --force {{api_image_name_dev}} {{no_output}}
    -docker image rm --force {{webapp_image_name_dev}} {{no_output}}
    docker system prune --force
    docker ps --all

compose-up-dev:
    @just compose-down-all
    -just webapp-build-dev {{no_output}}
    docker compose --file {{compose_file_path_dev}} up --detach
    docker ps --all

api-build-dev:
    docker build \
    --file {{containerfile_path_dev}} \
    --tag {{api_image_name_dev}} \
    ./api

webapp-build-dev:
    docker build \
        --file {{webapp_containerfile_path_dev}} \
        --tag {{webapp_image_name_dev}} \
        ./webapp

sh-api-dev:
    docker exec -it {{api_container_name_dev}} bash

### TESTING ###

compose_file_path_test := "compose.test.yml"
api_container_name_test := env_var_or_default("phoenix_container", "time_manager_phoenix_api_test")
api_image_name := "phoenix_api"
webapp_image_name := "vue_webapp"
vue_container_name_test := env_var_or_default("vue_container", "time_manager_vue_webapp_test")

api-build-test:
    docker build \
    --file {{containerfile_path_dev}} \
    --tag {{api_image_name}}:test \
    ./api

webapp-build-test:
    docker build \
        --file {{webapp_containerfile_path_dev}} \
        --tag {{webapp_image_name_dev}} \
        ./webapp

compose-down-test:
    @echo "Removing the test compose cluster..."
    @-docker compose --file {{compose_file_path_test}} down {{no_output}}
    @echo "Removing the test Phoenix API image..."
    @-docker image rm --force {{api_image_name}}:test {{no_output}}
    @echo "Removing the test Vue Webapp image..."
    @-docker image rm --force {{webapp_image_name}}:test {{no_output}}
    docker system prune --force
    docker ps --all

compose-up-test:
    @just compose-down-all
    @echo "Building the test Vue Webapp image..."
    @-just webapp-build-test {{no_output}}
    @echo "Building the test Phoenix API image..."
    @-just api-build-test {{no_output}}
    @echo "Creating the test Compose cluster..."
    @docker compose --file {{compose_file_path_test}} up --detach
    docker images
    docker ps --all

sh-api-test:
    docker exec -it {{api_container_name_test}} bash

ci-exec args:
    docker exec {{vue_container_name_test}} bash -c '{{args}}'

### PRODUCTION ###

# Relative to the Justfile 
containerfile_path_prd := "./api/Containerfile.prd"
# Relative to the Justfile
compose_file_path_prd := "compose.prd.yml" 

api_image_name_prd := "phoenix_api:prd"
api_container_name_prd := "time_manager_phoenix_api_prd"


webapp_containerfile_path_prd := './webapp/Containerfile.prd'
webapp_image_name_prd := "vue_webapp:prd"
webapp_container_name_prd := "time_manager_vue_webapp_prd"


compose-down-prd:
    -docker compose --file {{compose_file_path_prd}} down {{no_output}}
    -just api-remove-image-prd {{no_output}}
    -just webapp-remove-image-prd {{no_output}}
    docker system prune --force
    docker ps --all

compose-up-prd:
    @just compose-down-all
    just api-build-prd
    just webapp-build-prd
    docker compose --file {{compose_file_path_prd}} up --detach
    docker compose -f {{compose_file_path_prd}} logs --follow 

api-build-prd:
    docker build \
    --file {{containerfile_path_prd}} \
    --tag {{api_image_name_prd}}

api-remove-image-prd:
    docker image rm -f {{api_image_name_prd}}

webapp-remove-image-prd:
    docker image rm -f {{webapp_image_name_prd}}

webapp-build-prd:
    docker build \
    --file {{webapp_containerfile_path_prd}} \
    --tag {{webapp_image_name_prd}}



	
