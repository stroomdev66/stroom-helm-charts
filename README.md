# stroom-kubernetes
This repository contains [Helm](https://helm.sh) charts that assist with the configuration and deployment of a [Stroom](https://github.com/gchq/stroom) stack to a Kubernetes cluster.

It is being developed against the [Stroom v6.1 branch](https://github.com/gchq/stroom-resources/tree/6.1), with the intent of being forwards-compatible with v7 once that becomes stable.

This project uses [gchq/stroom-resources](https://github.com/gchq/stroom-resources) as a reference guide, though it is not dependent on it. 

## 1. Design goals

- Integrate Stroom into production Kubernetes environments using current and supported tooling (such as Helm)
- Replace the existing bespoke bootstrap scripts and resources, with a collection of Helm charts. This improves maintainability and simplifies on-boarding
- Simplify deployment, such as by removing the need to track and allocate port assignments for Stroom stack components
- Remove Nginx reverse proxies, replacing them with [Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress) resources
- Simplify operations management, by allowing admins to use cluster management tools like [Rancher](https://rancher.com) to deploy and configure Stroom resources
- Support both production-ready deployments and development environments (e.g. using [Minikube](https://minikube.sigs.k8s.io)), while using the same architecture and code base
- Attain performance parity (or near to), compared to bare-metal installs
- Improve observability through [Prometheus exporters](https://prometheus.io/docs/instrumenting/exporters)
- Improve security by implementing Kubernetes hardening guidelines

## 2. Feature status

This project is currently in alpha.

The following Helm charts have been completed to the point of being functional:

* [x] Core Stroom stack
    * [x] Processing / UI node
      * [ ] Dedicated processing / UI nodes
    * [x] MySQL (single instance, no replication)
    * [x] Zookeeper
    * [x] Kafka
    * [x] Authentication service and UI
* [ ] Stroom services
    * [ ] Stroom stats
    * [ ] Stroom proxy
    * [ ] Solr
    * [ ] Log sender
    * [ ] HBase
    * [ ] HDFS
* [ ] Prometheus exporters
* [ ] Logging and audit transport
* [ ] Security hardening
    * [ ] TLS for all services
    * [ ] Non-root containers
    * [ ] Service accounts and cluster role bindings
* [ ] Documentation (integration with [`gchq/stroom-docs`](https://github.com/gchq/stroom-docs)?)

## 3. Getting started

### Prerequisites

* A Kubernetes cluster, such as Minikube or [K3s](https://rancher.com/docs/k3s)
* [Helm](https://helm.sh) installed
* A DNS entry pointing to the Kubernetes Ingress. Recommendation is for this DNS record to point to a high-availability load balancer, such as what's described in the [Rancher docs](https://rancher.com/docs/k3s/latest/en/architecture/#high-availability-with-an-external-db)
* A [Kubernetes TLS secret](https://kubernetes.io/docs/concepts/configuration/secret/#tls-secrets) for that DNS entry, created in the same namespace that Stroom will be deployed into
* Enough available (i.e. unbound) [persistent volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes) to support the number of replicas requested of each Helm chart. The choice of storage provider is entirely up to you. Ensure each persistent volume has at least the capacity configured for the relevant component, otherwise it won't be bound by the Persistent Volume Claim (PVC) created by the Helm chart, and the Stroom stack won't start up.

### Stage files

Clone this repository to a directory on a machine that has `kubectl` and Kubernetes cluster admin rights

### Deploy

1. `cd` into `./charts/stroom`
1. Make any customisations to `./values/example.yaml`, such as setting the cluster name, or the number of processing node replicas
1. Ensure the following are set in `./values/example.yaml`:
  1. `global.advertisedHost`. FQDN of the Kubernetes ingress (e.g. `stroom.example.com`)
  1. `global.ingress.tls.secretName`. Name of the TLS secret
1. Create a namespace for the Stroom deployment: `kubectl create namespace stroom-dev`
1. Deploy the Helm chart, applying your customisations: `helm install -n stroom-dev -f ./values/defaults.yaml stroom .`

Stroom will now deploy to the namespace you created (in this case: `stroom-dev`). Cluster resources will be named using the release name `stroom` as a base.

To check on the status of the deployment, execute a command like: `watch kubectl get all -n stroom-dev`.

### Upgrade

1. Clone the updated repository 
1. Re-apply any customisations to `./values/example.yaml`
1. Follow steps 1 - 3 as described above
1. Upgrade the chart: `helm upgrade -n stroom-dev -f ./values/defaults.yaml stroom .`

### Open Stroom

Open the following in your web browser: `https://<FQDN>`

## 4. Contributing

As this project is still early in development, it is not yet open to public contributions.
