#build container
docker build -t simple-node-status-dev status/.

# Remove container anterior, se existir
docker rm -f status-dev || true

#exec container
docker run -d -p 3000:3000 --name status-dev simple-node-status-dev