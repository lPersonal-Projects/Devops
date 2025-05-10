#build container
docker build -t simple-node-status-dev status/.

#exec container
docker run -d -p 3000:3000 --name status-dev simple-node-status-dev