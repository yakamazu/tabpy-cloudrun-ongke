# function
Running Tabpy on Cloud Run on GKE

# Premise
Use cloud shell

# Create GKE cluster (sample)
Set up below for reference
https://cloud.google.com/run/docs/gke/setup

```shell: sample
gcloud beta container clusters create <cluster-name> \
   --machine-type = g1-small \
   --preemptible \
   --num-nodes = 3 \
   --disk-size = 10 \
   --zone = us-central1-a \
   --addons = HorizontalPodAutoscaling, HttpLoadBalancing, Istio, CloudRun \
   --cluster-version = latest \
   --enable-stackdriver-kubernetes \
   --enable-ip-alias \
   --scopes cloud-platform
```

# Deploy for Cloud Run on GKE
## Change Tabpy user name and password in Dockerfile to arbitrary values

```Dockerfile:
# Change this part
tabpy-user-management add -u <username> -p <password> -f pwd.txt
```

## Create a Docker image
Execute the following command in the directory where Dockerfile is stored.
An image called tabpy-sample is created.

```shell:
docker image build -t asia.gcr.io/<project-id>/tabpy-sample:latest.
```

## PUSH of Docker image
Push to Container Registry

```shell:
docker push asia.gcr.io/<project-id>/tabpy-sample:latest
```

## Deploy to Cloud Run

```shell: CloudRunOnGKE
gcloud beta run deploy tabpy-sample \
   --image asia.gcr.io/<project-id>/tabpy-sample \
   --platform gke \
   --cluster <clouster-name> \
   --cluster-location <location-name>
```

## Mapping custom domains
https://cloud.google.com/run/docs/mapping-custom-domains?hl=en

When deployed on Cloudrun on GKE,
By default the service can not be accessed unless the host is specified in the header via curl
In Tableau's external connection service, headers cannot be specified, so it is necessary to access by mapping a custom domain


### Verify domain ownership
```shell:
gcloud domains verify [DOMAIN]
```

### Map domain to service
```shell:
gcloud beta run domain-mappings create --service [SERVICE] --domain [DOMAIN]
```

### Get DNS record data
```shell:
gcloud beta run domain-mappings describe --domain [DOMAIN]
```

### Reservation of fixed IP (when using Cloudrun on GKE)
```shell:
gcloud compute addresses create [IP-NAME] --addresses [EXTERNAL-IP] --region [REGION]
```

EXTERNAL-IP specifies the IP address of the A record acquired in the procedure for acquiring DNS record data


### Add DNS record at domain registrar
https://cloud.google.com/run/docs/mapping-custom-domains?hl=en#dns_update

# Access Tabpy
Access Tabpy from Tableau's external service connection management
