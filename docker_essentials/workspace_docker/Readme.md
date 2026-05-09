# Codeless docker

## colima usage

```bash
brew install colima docker docker-compose

colima start --vm-type=vz --runtime docker --cpu 4 --memory8
docker context use colima

docker version
docker info
```

### Colima Management

```bash
colima status
colima stop
colima start
colima delete
