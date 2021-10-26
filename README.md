# doe-scaffold-tool-kind

## Initialize submodules 
Use following command in order to initialize submodules.
```shell
git submodule update --init --recursive
```

## Prerequisite

### Keep Calm And Read
Read documentation here: https://github.com/OuestFrance-Multimedia/doe-tool-bash-k8s-lab

### Install
Use following command in order to install k8s lab's tools.
```shell
make -f modules/doe-tool-bash-k8s-lab/Makefile install
```
### Prepare configuration
Generate .env and kind-config.yaml files just as explain here: https://github.com/OuestFrance-Multimedia/doe-tool-bash-k8s-lab#prerequisite

### Create Symbolic Links
Use following command in order to create required symbolic links.
```shell
make create-symbolic-links
```

## Create Cluster
Use following command in order to create cluster.
```shell
create-cluster
```

## Destroy Cluster
Use following command in order to destroy cluster.
```shell
destroy-cluster
```

## Prepare your App 

### Create env file
Use following command in order to create your App env's file.
```shell
cat << EOF > app1.env
APP=app1
EOF
```

### Import as submodules content-app & platform-configuration-helm

```shell
git submodule add --branch master git@gitlab.com:${GROUP}/${PATH}/${TEAM}/content-app-${APP}.git modules/content-app-${APP}
```

```shell
git submodule add --branch unrestricted git@gitlab.com:${GROUP}/${PATH}/${TEAM}/platform-configuration-helm-${APP}.git modules/platform-configuration-helm-${APP}
```