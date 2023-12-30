apiVersion: k0sctl.k0sproject.io/v1beta1
kind: Cluster
metadata:
  name: ${cluster_name}
spec:
  hosts:
${hosts}
  k0s:
    version: ${k0s_version}
    dynamicConfig: false
    config:
${cluster_config}