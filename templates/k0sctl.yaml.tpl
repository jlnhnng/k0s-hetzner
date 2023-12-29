apiVersion: k0sctl.k0sproject.io/v1beta1
kind: Cluster
metadata:
  name: k0s-cluster
spec:
  hosts:
  - ssh:
      address: 10.0.1.1
      user: root
      port: 22
      keyPath: ~/.ssh/id_rsa
      bastion:
        address: ${public-bastionhost-address}
        user: root
        keyPath: ~/.ssh/id_rsa
    role: controller+worker
    privateAddress: 10.0.1.1
    installFlags:
    - --kubelet-extra-args=--cloud-provider=external
  - ssh:
      address: 10.0.1.2
      user: root
      port: 22
      keyPath: ~/.ssh/id_rsa
      bastion:
        address: ${public-bastionhost-address}
        user: root
        keyPath: ~/.ssh/id_rsa
    role: controller+worker
    privateAddress: 10.0.1.2
    installFlags:
    - --kubelet-extra-args=--cloud-provider=external
  - ssh:
      address: 10.0.1.3
      user: root
      port: 22
      keyPath: ~/.ssh/id_rsa
      bastion:
        address: ${public-bastionhost-address}
        user: root
        keyPath: ~/.ssh/id_rsa
    role: controller+worker
    privateAddress: 10.0.1.3
    installFlags:
    - --kubelet-extra-args=--cloud-provider=external
  - ssh:
      address: 10.0.1.10
      user: root
      port: 22
      keyPath: ~/.ssh/id_rsa
      bastion:
        address: ${public-bastionhost-address}
        user: root
        keyPath: ~/.ssh/id_rsa
    role: worker
    privateAddress: 10.0.1.10
    installFlags:
    - --kubelet-extra-args=--cloud-provider=external
  - ssh:
      address: 10.0.1.11
      user: root
      port: 22
      keyPath: ~/.ssh/id_rsa
      bastion:
        address: ${public-bastionhost-address}
        user: root
        keyPath: ~/.ssh/id_rsa
    role: worker
    privateAddress: 10.0.1.11
    installFlags:
    - --kubelet-extra-args=--cloud-provider=external
  - ssh:
      address: 10.0.1.12
      user: root
      port: 22
      keyPath: ~/.ssh/id_rsa
      bastion:
        address: ${public-bastionhost-address}
        user: root
        keyPath: ~/.ssh/id_rsa
    role: worker
    privateAddress: 10.0.1.12
    installFlags:
    - --kubelet-extra-args=--cloud-provider=external
  k0s:
    version: 1.24.4+k0s.0
    config:
      apiVersion: k0s.k0sproject.io/v1beta1
      kind: Cluster
      metadata:
        name: hetzner-k0s
      spec:
        api:
          externalAddress: ${loadbalancer-address}
          sans:
          - ${loadbalancer-address}
          - 10.0.1.1
          - 10.0.1.2
          - 10.0.1.3
          k0sApiPort: 9443
          port: 6443
        installConfig:
          users:
            etcdUser: etcd
            kineUser: kube-apiserver
            konnectivityUser: konnectivity-server
            kubeAPIserverUser: kube-apiserver
            kubeSchedulerUser: kube-scheduler
        konnectivity:
          adminPort: 8133
          agentPort: 8132
        network:
          kubeProxy:
            disabled: false
            mode: iptables
          kuberouter:
            autoMTU: true
            mtu: 0
            peerRouterASNs: ""
            peerRouterIPs: ""
          podCIDR: 10.0.16.0/20
          provider: kuberouter
          serviceCIDR: 10.0.8.0/21
        storage:
          type: etcd
        telemetry:
          enabled: false