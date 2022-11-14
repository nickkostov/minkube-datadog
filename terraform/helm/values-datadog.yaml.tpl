# Datadog Agent with Datadog Cluster Agent and
# OrchestratorExplorer (Live Containers), Check Runners, and
# External Metrics Server enabled
registry: docker.io/datadog
targetSystem: "linux"
datadog:
  apiKey: ${api_key}
  appKey: ${app_key}
  site: datadoghq.eu
  # If not using secrets, then use apiKey and appKey instead
  #apiKeyExistingSecret: <DATADOG_API_KEY_SECRET>
  #appKeyExistingSecret: <DATADOG_APP_KEY_SECRET>
  kubelet:
    tlsVerify: "false"
  clusterName: minikube
  tags: []
  processAgent:
    enabled: true
    processCollection: true
    stripProcessArguments: true
    processDiscovery: true
  osReleasePath: /etc/os-release
  systemProbe:
    debugPort: 0
    enableConntrack: true
    seccomp: localhost/system-probe
    seccompRoot: /var/lib/kubelet/seccomp
    bpfDebug: false
    apparmor: unconfined
    enableTCPQueueLength: false
    enableOOMKill: false
    enableRuntimeCompiler: false
    enableKernelHeaderDownload: true
    mountPackageManagementDirs: []
    runtimeCompilationAssetDir: /var/tmp/datadog-agent/system-probe
    collectDNSStats: true
    maxTrackedConnections: 131072
    conntrackMaxStateSize: 131072 
    conntrackInitTimeout: 10s
    enableDefaultOsReleasePaths: true
    enableDefaultKernelHeadersPaths: true
  orchestratorExplorer:
    enabled: true
clusterAgent:
  replicas: 1
  rbac:
    create: true
    serviceAccountName: default
  metricsProvider:
    enabled: true
    createReaderRbac: true
    useDatadogMetrics: true
    service:
      type: ClusterIP
      port: 8443
agents:
  rbac:
    create: true
    serviceAccountName: default
kubeStateMetricsCore:
  # datadog.kubeStateMetricsCore.enabled -- Enable the kubernetes_state_core check in the Cluster Agent (Requires Cluster Agent 1.12.0+)
  ## ref: https://docs.datadoghq.com/integrations/kubernetes_state_core
  enabled: true