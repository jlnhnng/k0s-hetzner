      apiVersion: k0s.k0sproject.io/v1beta1
      kind: ClusterConfig
      metadata:
        name: k0s
      spec:
        api:
          address: ${external_ip}
          port: 6443
          k0sApiPort: 9443
          externalAddress: ${external_hostname}
          sans:
            - ${external_ip}
        storage:
          type: etcd
          etcd:
            peerAddress: ${external_ip}
        network:
          podCIDR: ${pod_cidr}
          serviceCIDR: ${service_cidr}
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
          enabled: true
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