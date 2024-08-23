Steps:

1. Maven Package the clients 
..........................
english and spanish

2. docker build images
......................
docker build -t example/englishclient .

docker build -t example/spanishclient .


3. kubectl apply
...................
   config map , servers and clients files

Cleanup:
delete using kubectl
