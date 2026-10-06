```bash
docker build -t backend_img .

docker run --name backend --hostname backend1 -d -p 8080:8080 backend_img
docker run --name backend --hostname backend2 -d -p 8080:8080 backend_img
docker run --name backend --hostname backend3 -d -p 8080:8080 backend_img

curl http://0.0.0.0:8080


for i in {1..100}; do
    curl -s https://load-balancer.vulebaolong.com
done
```