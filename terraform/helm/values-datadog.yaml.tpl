# Datadog Agent with Datadog Cluster Agent and
# OrchestratorExplorer (Live Containers), Check Runners, and
# External Metrics Server enabled

registry: docker.io/datadog
targetSystem: "linux"
datadog:
  apiKey: ${api_key}
  appKey: ${app_key}
  site: ${datadog_site}
  # If not using secrets, then use apiKey and appKey instead
  #apiKeyExistingSecret: <DATADOG_API_KEY_SECRET>
  #appKeyExistingSecret: <DATADOG_APP_KEY_SECRET>
  kubelet:
    tlsVerify: "false"
  clusterName: ${cluster_name}
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
    container_scrubbing:
      enabled: true
  containerExclude:  # "image:datadog/agent"
  # as a space-separated list
  containerExcludeLogs:
  logs:
    enabled: true
    containerCollectAll: true
    ## It's usually the most efficient way of collecting logs.
    ## ref: https://docs.datadoghq.com/agent/basic_agent_usage/kubernetes/#log-collection-setup
    ### EXPLORE ###
    containerCollectUsingFiles: true
    # datadog.logs.autoMultiLineDetection -- Allows the Agent to detect common multi-line patterns automatically.
    ## ref: https://docs.datadoghq.com/agent/logs/advanced_log_collection/?tab=configurationfile#automatic-multi-line-aggregation
    autoMultiLineDetection: false
  resources:
    requests:
      cpu: 200m
      memory: 256Mi
    limits:
      cpu: 200m
      memory: 256Mi
  containerRuntimeSupport:
    enabled: true
  helmCheck:
    # datadog.helmCheck.enabled -- Set this to true to enable the Helm check (Requires Agent 7.35.0+ and Cluster Agent 1.19.0+)
    # This requires clusterAgent.enabled to be set to true
    enabled: true
    # datadog.helmCheck.collectEvents -- Set this to true to enable event collection in the Helm Check (Requires Agent 7.36.0+ and Cluster Agent 1.20.0+)
    # This requires datadog.HelmCheck.enabled to be set to true
    collectEvents: true
    # datadog.helmCheck.valuesAsTags -- Collects Helm values from a release and uses them as tags (Requires Agent and Cluster Agent 7.40.0+).
    # This requires datadog.HelmCheck.enabled to be set to true
    valuesAsTags: {}
clusterAgent:
  enabled: true
  image:
    name: cluster-agent
    tag: 7.40.1
    digest: ""
    repository:
    pullPolicy: IfNotPresent
#  nodeSelector: {}
  replicas: 1
  rbac:
    create: true
    serviceAccountName: default
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
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
  resources:
    requests:
      cpu: 200m
      memory: 256Mi
    limits:
      cpu: 200m
      memory: 256Mi
kubeStateMetricsCore:
  # datadog.kubeStateMetricsCore.enabled -- Enable the kubernetes_state_core check in the Cluster Agent (Requires Cluster Agent 1.12.0+)
  ## ref: https://docs.datadoghq.com/integrations/kubernetes_state_core
  enabled: true
#providers:
#  eks:
#    ec2:
#      # providers.eks.ec2.useHostnameFromFile -- Use hostname from EC2 filesystem instead of fetching from metadata endpoint.
#      ## When deploying to EC2-backed EKS infrastructure, there are situations where the
#      ## IMDS metadata endpoint is not accesible to containers. This flag mounts the host's
#      ## `/var/lib/cloud/data/instance-id` and uses that for Agent's hostname instead.
#      useHostnameFromFile: false