# COVID-19 Shiny app

A dockerized Shiny app to display and forecast COVID-19 daily cases

Pull parent images:

```bash
docker pull rhub/r-minimal:4.0.5
docker pull rocker/r-base:4.0.4
docker pull rocker/r-ubuntu:20.04
docker pull rstudio/r-base:4.0.4-focal
docker pull rocker/shiny:4.0.5
docker pull rocker/r-bspm:20.04
docker pull eddelbuettel/r2u:focal
```

Initial parent image sizes (May 2021):

```bash
$ docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}'

REPOSITORY          TAG                 SIZE
rhub/r-minimal      4.0.5              35.2MB
rocker/r-base       4.0.4               761MB
rocker/r-ubuntu     20.04               673MB
rstudio/r-base      4.0.4-focal         894MB
rocker/shiny        4.0.5              1.37GB
rocker/r-bspm       20.04               758MB
eddelbuettel        r2u:focal           804MB

```

Need `docker --version` >18.09 for BuildKit.

Used a 2015 MacBook Pro for the build times recorded here.

Tested images with `docker run -p 8080:3838 $IMAGE`.

## rhub/r-minimal:4.0.5

Total build time: 1634.8 sec building packages from source

```bash
export IMAGE="analythium/covidapp-shiny:minimal"
export FILE="Dockerfile.minimal"
DOCKER_BUILDKIT=1 docker build --no-cache -f $FILE -t $IMAGE .
```

## rocker/r-base:4.0.4

Total build time: 693.1 sec building packages from source, 174.1 sec installing packages from binary

```bash
export IMAGE="analythium/covidapp-shiny:base"
export FILE="Dockerfile.base"
DOCKER_BUILDKIT=1 docker build --no-cache -f $FILE -t $IMAGE .
```

## rocker/r-ubuntu:20.04

Total build time: 716.7 sec building packages from source, 187.6 sec installing packages from binary

```bash
export IMAGE="analythium/covidapp-shiny:ubuntu"
export FILE="Dockerfile.ubuntu"
DOCKER_BUILDKIT=1 docker build --no-cache -f $FILE -t $IMAGE .
```

## rstudio/r-base:4.0.4-focal

Total build time: 186.2 sec installing packages from binary

```bash
export IMAGE="analythium/covidapp-shiny:focal"
export FILE="Dockerfile.focal"
DOCKER_BUILDKIT=1 docker build --no-cache -f $FILE -t $IMAGE .
```

## rocker/shiny:4.0.5

Total build time: 136.0 sec installing packages from binary

```bash
export IMAGE="analythium/covidapp-shiny:shiny"
export FILE="Dockerfile.shiny"
DOCKER_BUILDKIT=1 docker build --no-cache -f $FILE -t $IMAGE .
```

## rocker/r-bspm:20.04

Total build time: 140.1 sec installing packages from binary

```bash
export IMAGE="analythium/covidapp-shiny:bspm"
export FILE="Dockerfile.bspm"
DOCKER_BUILDKIT=1 docker build --no-cache -f $FILE -t $IMAGE .
```

## eddelbuettel/r2u:focal

Total build time: 32.5 sec installing packages using `apt-get`

```bash
export IMAGE="analythium/covidapp-shiny:r2u"
export FILE="Dockerfile.r2u"
DOCKER_BUILDKIT=1 docker build --no-cache -f $FILE -t $IMAGE .
```

## Sizes

```bash
docker images \
    --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}' \
    analythium/covidapp-shiny

REPOSITORY                  TAG                 SIZE
analythium/covidapp-shiny   minimal             349MB
analythium/covidapp-shiny   base                1.05GB
analythium/covidapp-shiny   ubuntu              1.22GB
analythium/covidapp-shiny   focal               1.38GB
analythium/covidapp-shiny   shiny               1.61GB
analythium/covidapp-shiny   bspm                1.31GB
analythium/covidapp-shiny   r2u                 959MB
```


```r
x = data.frame(TAG=c("minimal", "base", "ubuntu", "focal", "shiny", "bspm", "r2u"),
  PARENT_SIZE=c(35, 761, 673, 894, 1380, 758, 804) / 1000, # base image
  FINAL_SIZE=c(222 / 1000, 1.05, 1.22, 1.38, 1.61, 1.31, 0.959)) # final image
x$DIFF = x$FINAL_SIZE - x$PARENT_SIZE

      TAG PARENT_SIZE FINAL_SIZE  DIFF
1 minimal       0.035      0.222 0.187
2    base       0.761      1.050 0.289
3  ubuntu       0.673      1.220 0.547
4   focal       0.894      1.380 0.486
5   shiny       1.380      1.610 0.230
6    bspm       0.758      1.310 0.552
7     r2u       0.804      0.959 0.155
```

Diff is similar (Ubuntu is larger likely because of different system libraries).
Final image size reflects base image sizes.

## Links

- [rstudio/r-system-requirements](https://github.com/rstudio/r-system-requirements), [browse the database](https://packagemanager.rstudio.com/client/#/repos/2/packages)
- [r-hub/sysreqsdb](https://github.com/r-hub/sysreqsdb)
- [r-universe](https://r-universe.dev/)
- [maketools](https://cran.r-project.org/web/packages/maketools/vignettes/sysdeps.html)
- [r2u](https://eddelbuettel.github.io/r2u/)
