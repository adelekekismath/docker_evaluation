#creer un network qui englobe tout les serveurs
docker network create workplan

#builder les images 
docker build -f DockerfileWorker -t workplan/worker .
docker build -f DockerfilePlanner -t workplan/planner .

#creer et demarrer les containers (worker et planner)
docker run --network=workplan -e PORT=3000 -e  TASKS=4  --name planner -d workplan/planner 
docker run --network=workplan -e PORT=8080 -e PLANNER=http://planner:3000  --name worker -d workplan/worker

#creer et demarrer les containers (worker1, worker2, worker3)
docker run --network=workplan -e PORT=8080 -e PLANNER=http://planner:3000  --name worker1 -d workplan/worker
docker run --network=workplan -e PORT=8080 -e PLANNER=http://planner:3000  --name worker2 -d workplan/worker
docker run --network=workplan -e PORT=8080 -e PLANNER=http://planner:3000  --name worker3 -d workplan/worker

#supprimer les workers pour les redemarer avec les variables d'environnement
docker rm worker -f
docker rm worker1 -f
docker rm worker2 -f
docker rm worker3 -f

#demarrer les workers avec les variables d'environnement
docker run --network=workplan -e PORT=8080 -e MULT=false -e PLANNER=http://planner:3000  --name worker -d  workplan/worker
docker run --network=workplan -e PORT=8080 -e ADD=false -e PLANNER=http://planner:3000  --name worker1 -d  workplan/worker
docker run --network=workplan -e PORT=8080 -e MULT=false -e PLANNER=http://planner:3000  --name worker2 -d  workplan/worker
docker run --network=workplan -e PORT=8080 -e ADD=false -e PLANNER=http://planner:3000  --name worker3 -d  workplan/worker

#Apres le lancement des commandes ci -dessus j'ai remarqué que lorsque un worker n'a pas le meme type que la task
#il renvoie une erreur de invalid json, du coup j'ai rajouté attribut type dans la table workers pour verifier 
#le type avant de lui attribuer une tache

#ajout de la variable ADDRESS

docker run --network=workplan -e PORT=8080 -e MULT=false -e PLANNER=http://planner:3000 -e ADDRESS=http://worker:8080 --name worker -d  workplan/worker
docker run --network=workplan -e PORT=8080 -e ADD=false -e PLANNER=http://planner:3000 -e ADDRESS=http://worker1:8080 --name  worker1 -d  workplan/worker
docker run --network=workplan -e PORT=8080 -e MULT=false -e PLANNER=http://planner:3000 -e ADDRESS=http://worker2:8080  --name worker2 -d  workplan/worker
docker run --network=workplan -e PORT=8080 -e ADD=false -e PLANNER=http://planner:3000 -e ADDRESS=http://worker3:8080 --name worker3 -d  workplan/worker

#j'ai pas reussi a demarrer enregistrer dynamiquement les workers, je pense que c'est parce que j'ai changé le code 
#qui gere les erreurs
