# COVID-19 Shiny app

A dockerized Shiny app to display and forecast COVID-19 daily cases

The basic approach uses `install.r` and `R -e install.packages()` to install dependencies.

```bash
# name of the Docker image
export IMAGE="analythium/covidapp-shiny:basic"

# build image
docker build -t $IMAGE .

# run and test locally
docker run -p 8080:3838 $IMAGE
# visit http://localhost:8080 to see the app

# push image to registry
docker push $IMAGE
```


