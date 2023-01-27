#creer un network qui englobe tout les serveurs
docker network create workplan

#builder les images 
docker build -f DockerfileWorker -t workplan/worker .
docker build -f DockerfilePlanner -t workplan/planner .

#creer et demarrer les containers 
docker run --network=workplan -e PORT=3000 -e  TASKS=4  --name planner -d workplan/planner 
docker run --network=workplan -e PORT=8080 -e PLANNER=http://planner:3000  --name worker -d workplan/worker

