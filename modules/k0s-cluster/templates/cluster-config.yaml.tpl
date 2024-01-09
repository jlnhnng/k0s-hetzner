apiVersion: k0s.k0sproject.io/v1beta1
kind: ClusterConfig
metadata:
  name: k0s
spec:
  api:
    #address: ${external_ip}
    port: 6443
    k0sApiPort: 9443
    #externalAddress: ${external_ip}
    # sans:
    #   - ${external_ip}
  storage:
    type: etcd
    # etcd:
    #   peerAddress: ${external_ip}
  network:
    provider: kuberouter
    calico: null
    kuberouter:
      mtu: 0
      peerRouterIPs: ""
      peerRouterASNs: ""
      autoMTU: true
  podSecurityPolicy:
    defaultPolicy: 00-k0s-privileged
  telemetry:
    enabled: false
  installConfig:
    users:
      etcdUser: etcd
      kineUser: kube-apiserver
      konnectivityUser: konnectivity-server
      kubeAPIserverUser: kube-apiserver
      kubeSchedulerUser: kube-scheduler
  konnectivity:
    agentPort: 8132
    adminPort: 8133
  extensions:
    helm:
      repositories:
        - name: hcloud
          url: https://charts.hetzner.cloud
        - name: traefik
          url: https://traefik.github.io/charts
      charts:
        - name: hcloud-csi
          chartname: hcloud/hcloud-csi
          version: "2.6.0"
          namespace: kube-system
          values: |
            node:
              kubeletDir: /var/lib/k0s/kubelet
              hostNetwork: true
        - name: hcloud-cloud-controller-manager
          chartname: hcloud/hcloud-cloud-controller-manager
          version: "1.19.0"
          namespace: kube-system
          values: |
            networking:
              enabled: true
        - name: traefik
          chartname: traefik/traefik
          version: v26.0.0
          namespace: default
          values: |
            service:
              annotations:
                load-balancer.hetzner.cloud/network-zone: eu-central
                load-balancer.hetzner.cloud/name: k0s-load-balancer
                load-balancer.hetzner.cloud/hostname: marmite.pastis-hosting.net