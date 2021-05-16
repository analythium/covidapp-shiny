# COVID-19 Shiny app

A dockerized Shiny app to display and forecast COVID-19 daily cases

The approach uses renv to install dependencies from `renv.lock` file.

```r
# initialize project & discovering dependencies
renv::init()

# save library state to lockfile
renv::snapshot()
```

```bash
# name of DOcker image
export IMAGE="analythium/covidapp-shiny:renv"

# build image
docker build -t $IMAGE .

# run and test locally
docker run -p 8080:3838 $IMAGE
# visit http://localhost:8080 to see the app

# push image to registry
docker push $IMAGE
```
