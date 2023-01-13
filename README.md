# We are setting up a Talos K8S Cluster using terraform (i.e. terragrunt) 

Resources 

We are using talos and talos terraform provider
- https://www.talos.dev/
- https://registry.terraform.io/providers/siderolabs/talos/0.1.0

also we are using terragrunt to wrap terraform
- https://www.terraform.io/
- https://terragrunt.gruntwork.io/

we are using Openstack Terraform provider
- https://registry.terraform.io/providers/terraform-provider-openstack/openstack/1.49.0

I have been trying this on 2 different OpenStack provider 
- https://elastx.se/en
- https://cleura.cloud/

To simplify setup all tooling is contained in a docker container i.e. ref /tooling

So to follow along one needs to clone this repo and run the 'environment.sh' script

next you need to go into the openstack of choice and get a 'Openstack RC file'

```bash 

export OS_USERNAME=talos_admin
export OS_PASSWORD="REDACTED"
export OS_AUTH_URL=https://kna1.citycloud.com:5000/v3
export OS_USER_DOMAIN_NAME=CCP_Domain_5555
export OS_PROJECT_DOMAIN_NAME=CCP_Domain_5555
export OS_REGION_NAME=Kna1
export OS_PROJECT_NAME="Talos_poc"
export OS_TENANT_NAME="Talos_poc"
export OS_AUTH_VERSION=3
export OS_IDENTITY_API_VERSION=3

```

For example, I can go into my Cleura console and ...
- Create a project 'Talos_poc'
- Create a user 'talos_admin'
- download a file similar to shown above

However, there seams to be some sort of issue means I have to append '/v3' to the auth URL for it to work smooth!  

now in the included .gitignore there is ignored folder named secrets s if we place it there we can then 'source' it ...

```bash
source /home/secrets/openstack-rc
```

Now we need to have bucket to use for terraform-remote-backend

```bash
openstack container create cleura-talos-poc 
```

Now we also need S3 compatible credentials to use 

```bash
openstack ec2 credentials create
```

using the accesskey and secrect we now need to append the following to '/home/secrets/openstack-rc'

```bash

export OS_S3_REGION_NAME="Kna1"
export OS_S3_ENCRYPT="true"
export OS_S3_ENDPOINT="s3-kna1.citycloud.com:8080"
export OS_S3_ACCESS_KEY="REDACTED"
export OS_S3_SECRET_KEY="REDACTED"
```

and again we need to source the added credentials

```bash
source /home/secrets/openstack-rc
```

next you will need to replace the values in 'live/cleura/environment.yaml'

first we pick if we should expose it using a floating IP (yes for now ...)

```
use_fip: true
```

Then we need to name it any name will work

```
  cluster_name: "cleuratalospoc",
  environment: "cleuratalospoc",
```

Then we need to download right image from talos and upload it as image to Openstack cloud

I downloaded the newest 1.3.2 (https://github.com/siderolabs/talos/releases/download/v1.3.2/openstack-amd64.tar.gz) untar it and then we name it talos_132

```bash
openstack image create --private --disk-format raw --file /home/secrets/disk.raw talos_132
```

then we need the image id we get here

```
  image_uuid: "d44757d4-c381-45e1-ba4b-7bf135d9aca8",
```

Pick number and size for worker and ctrl plane, use cmd below and pick something to taste

```bash
openstack flavor list
```

```
  control_plane_flavor: "2C-2GB-20GB",
  control_plane_number: 3,
  worker_flavor: "2C-2GB-50GB",
  worker_number: 3,
```

next I will use DNS to find the ctrl plane wo pick a domain which you control...  

```
domain: "example.com",
```

also we need to find the provider specified external network for internet access

```bash
openstack network list --external
```

grab the external name and ID

```
  external_network_name: "ext-net",
  external_network_id: "fba95253-5543-4078-b793-e2de58c31378",
```

we can now create openstack SDN ...
```bash
cd live/cleura/cluster/network
terragrunt apply
```

and the compute nodes needed ...
```bash
cd live/cleura/cluster/compute
terragrunt apply
```

```
Outputs:

controlplanes = [
"1.2.3.4",
"2.3.4.5",
"3.4.5.6",
]
dns = "cleuratalospoc.example.com"
machineconfig_controlplane = <sensitive>
machineconfig_worker = <sensitive>
talosconfig = <sensitive>
workers = [
"4.3.2.1",
]
```

now we need to use the output i.e. DNS and ip (controlplanes) and create CNAMES before we bootstrap
```bash
cd live/cleura/cluster/bootstrap
terragrunt apply
```

next we should create cloud credentials to get cinder-csi working

```bash
openstack application credential create k8s --unrestricted
```

To find tenantId, use
```bash
openstack project list
```

create secretes/cloud.conf

```bash
[Global]
auth-url = https://kna1.citycloud.com:5000/v3
application-credential-id=REDACTED
application-credential-secret=REDACTED
domain-name =CCP_Domain_5555
tenant-id =REDACTED
region = Kna1
```

create secret inside namespace kube-system

```bash
kubectl create secret -n kube-system generic cloud-config --from-file=/home/secrets/Synkzone_poc/cloud.conf
```

And install Cinder CSI
```bash
kubectl apply -k  /home/overlays/cinder-csi/
```

this should work ?
```bash
kubectl apply -f  overlays/verify/test_storage_nginx.yaml
```

Now do the same for ElastX ...