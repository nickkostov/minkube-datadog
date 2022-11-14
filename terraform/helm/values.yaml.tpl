nameOverride: "datadog"
#fullnameOverride:  # ""
targetSystem: "linux"
# commonLabels -- Labels to apply to all resources
commonLabels: {}
# team_name: dev
registry: docker.io/datadog
####################################### DATADOG AGENT #######################################
datadog:
  apiKey: ${api_key}
  # Use these to get the api keys from secrets:
  #apiKeyExistingSecret:  # <DATADOG_API_KEY_SECRET>
  #appKeyExistingSecret:  # <DATADOG_APP_KEY_SECRET>
  appKey: ${app_key}
  ## Configure the secret backend feature https://docs.datadoghq.com/agent/guide/secrets-management
  ## Examples: https://docs.datadoghq.com/agent/guide/secrets-management/#setup-examples-1
  secretBackend:
    # datadog.secretBackend.command -- Configure the secret backend command, path to the secret backend binary.

    ## Note: If the command value is "/readsecret_multiple_providers.sh", and datadog.secretBackend.enableGlobalPermissions is enabled below, the agents will have permissions to get secret objects across the cluster.
    ## Read more about "/readsecret_multiple_providers.sh": https://docs.datadoghq.com/agent/guide/secrets-management/#script-for-reading-from-multiple-secret-providers-readsecret_multiple_providerssh
    command:  # "/readsecret.sh" or "/readsecret_multiple_providers.sh" or any custom binary path

    # datadog.secretBackend.arguments -- Configure the secret backend command arguments (space-separated strings).
    arguments:  # "/etc/secret-volume" or any other custom arguments

    # datadog.secretBackend.timeout -- Configure the secret backend command timeout in seconds.
    timeout:  # 30

    # datadog.secretBackend.enableGlobalPermissions -- Whether to create a global permission allowing Datadog agents to read all secrets when `datadog.secretBackend.command` is set to `"/readsecret_multiple_providers.sh"`.
    enableGlobalPermissions: true

    # datadog.secretBackend.roles -- Creates roles for Datadog to read the specified secrets - replacing `datadog.secretBackend.enableGlobalPermissions`.
    roles: []
    # - namespace: secret-location-namespace
    #   secrets:
    #     - secret-1
    #     - secret-2
  securityContext:
    runAsUser: 0

  # datadog.hostVolumeMountPropagation -- Allow to specify the `mountPropagation` value on all volumeMounts using HostPath

  ## ref: https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation
  hostVolumeMountPropagation: None
  #clusterName: minkube-home-server
  site: datadoghq.eu

  # datadog.dd_url -- The host of the Datadog intake server to send Agent data to, only set this option if you need the Agent to send data to a custom URL
  ## Overrides the site setting defined in "site".
  #dd_url:  # https://app.datadoghq.com

  # datadog.logLevel -- Set logging verbosity, valid log levels are: trace, debug, info, warn, error, critical, off
  logLevel: INFO

  # datadog.kubeStateMetricsEnabled -- If true, deploys the kube-state-metrics deployment
####################################### KUBE STATE METRICS #######################################
  ## ref: https://github.com/kubernetes/kube-state-metrics/tree/kube-state-metrics-helm-chart-2.13.2/charts/kube-state-metrics
  # The kubeStateMetricsEnabled option will be removed in the 4.0 version of the Datadog Agent chart.
  kubeStateMetricsEnabled: true

  kubeStateMetricsNetworkPolicy:
    # datadog.kubeStateMetricsNetworkPolicy.create -- If true, create a NetworkPolicy for kube state metrics
    create: false

  kubeStateMetricsCore:
    # datadog.kubeStateMetricsCore.enabled -- Enable the kubernetes_state_core check in the Cluster Agent (Requires Cluster Agent 1.12.0+)

    ## ref: https://docs.datadoghq.com/integrations/kubernetes_state_core
    enabled: true

    rbac:
    # datadog.kubeStateMetricsCore.rbac.create -- If true, create & use RBAC resources
      create: true

    # datadog.kubeStateMetricsCore.ignoreLegacyKSMCheck -- Disable the auto-configuration of legacy kubernetes_state check (taken into account only when datadog.kubeStateMetricsCore.enabled is true)

    ## Disabling this field is not recommended as it results in enabling both checks, it can be useful though during the migration phase.
    ## Migration guide: https://docs.datadoghq.com/integrations/kubernetes_state_core/?tab=helm#migration-from-kubernetes_state-to-kubernetes_state_core
    ignoreLegacyKSMCheck: true

    # datadog.kubeStateMetricsCore.collectSecretMetrics -- Enable watching secret objects and collecting their corresponding metrics kubernetes_state.secret.*

    ## Configuring this field will change the default kubernetes_state_core check configuration and the RBACs granted to Datadog Cluster Agent to run the kubernetes_state_core check.
    collectSecretMetrics: true

    # datadog.kubeStateMetricsCore.collectVpaMetrics -- Enable watching VPA objects and collecting their corresponding metrics kubernetes_state.vpa.*

    ## Configuring this field will change the default kubernetes_state_core check configuration and the RBACs granted to Datadog Cluster Agent to run the kubernetes_state_core check.
    collectVpaMetrics: false

    # datadog.kubeStateMetricsCore.useClusterCheckRunners -- For large clusters where the Kubernetes State Metrics Check Core needs to be distributed on dedicated workers.

    ## Configuring this field will create a separate deployment which will run Cluster Checks, including Kubernetes State Metrics Core.
    ## ref: https://docs.datadoghq.com/agent/cluster_agent/clusterchecksrunner?tab=helm
    useClusterCheckRunners: false

    # datadog.kubeStateMetricsCore.labelsAsTags -- Extra labels to collect from resources and to turn into datadog tag.

    ## It has the following structure:
    ## labelsAsTags:
    ##   <resource1>:        # can be pod, deployment, node, etc.
    ##     <label1>: <tag1>  # where <label1> is the kubernetes label and <tag1> is the datadog tag
    ##     <label2>: <tag2>
    ##   <resource2>:
    ##     <label3>: <tag3>
    ##
    ## Warning: the label must match the transformation done by kube-state-metrics,
    ## for example tags.datadoghq.com/version becomes tags_datadoghq_com_version.
    labelsAsTags: {}
    #  pod:
    #    app: app
    #  node:
    #    zone: zone
    #    team: team

  ## Manage Cluster checks feature

  ## ref: https://docs.datadoghq.com/agent/autodiscovery/clusterchecks/
  ## Autodiscovery via Kube Service annotations is automatically enabled
  clusterChecks:
    # datadog.clusterChecks.enabled -- Enable the Cluster Checks feature on both the cluster-agents and the daemonset
    enabled: true
    # datadog.clusterChecks.shareProcessNamespace -- Set the process namespace sharing on the cluster checks agent
    shareProcessNamespace: false

  # datadog.nodeLabelsAsTags -- Provide a mapping of Kubernetes Node Labels to Datadog Tags
  nodeLabelsAsTags: {}
  #   beta.kubernetes.io/instance-type: aws-instance-type
  #   kubernetes.io/role: kube_role
  #   <KUBERNETES_NODE_LABEL>: <DATADOG_TAG_KEY>

  # datadog.podLabelsAsTags -- Provide a mapping of Kubernetes Labels to Datadog Tags
  podLabelsAsTags: {}
  #   app: kube_app
  #   release: helm_release
  #   <KUBERNETES_LABEL>: <DATADOG_TAG_KEY>

  # datadog.podAnnotationsAsTags -- Provide a mapping of Kubernetes Annotations to Datadog Tags
  podAnnotationsAsTags: {}
  #   iam.amazonaws.com/role: kube_iamrole
  #   <KUBERNETES_ANNOTATIONS>: <DATADOG_TAG_KEY>

  # datadog.namespaceLabelsAsTags -- Provide a mapping of Kubernetes Namespace Labels to Datadog Tags
  namespaceLabelsAsTags: {}
  #   env: environment
  #   <KUBERNETES_NAMESPACE_LABEL>: <DATADOG_TAG_KEY>

  # datadog.tags -- List of static tags to attach to every metric, event and service check collected by this Agent.

  ## Learn more about tagging: https://docs.datadoghq.com/tagging/
  tags: []
  #   - "<KEY_1>:<VALUE_1>"
  #   - "<KEY_2>:<VALUE_2>"

  # datadog.checksCardinality -- Sets the tag cardinality for the checks run by the Agent.

  ## ref: https://docs.datadoghq.com/getting_started/tagging/assigning_tags/?tab=containerizedenvironments#environment-variables
  checksCardinality:  # low, orchestrator or high (not set by default to avoid overriding existing DD_CHECKS_TAG_CARDINALITY configurations, the default value in the Agent is low)
####################################### KUBELET CONFIGURATION #######################################

  # kubelet configuration
  kubelet:
    # datadog.kubelet.host -- Override kubelet IP
    host:
      valueFrom:
        fieldRef:
          fieldPath: status.hostIP
    # datadog.kubelet.tlsVerify -- Toggle kubelet TLS verification
    # @default -- true
    tlsVerify: false
    # datadog.kubelet.hostCAPath -- Path (on host) where the Kubelet CA certificate is stored
    # @default -- None (no mount from host)
    #hostCAPath:
    ## datadog.kubelet.agentCAPath -- Path (inside Agent containers) where the Kubelet CA certificate is stored
    ## @default -- /var/run/host-kubelet-ca.crt if hostCAPath else /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    #agentCAPath:
    ## datadog.kubelet.podLogsPath -- Path (on host) where the PODs logs are located
    ## @default -- /var/log/pods on Linux, C:\var\log\pods on Windows
    podLogsPath:

  # datadog.expvarPort -- Specify the port to expose pprof and expvar to not interfer with the agentmetrics port from the cluster-agent, which defaults to 5000
  expvarPort: 6000
####################################### dogstatsd CONFIGURATION #######################################
  ## ref: https://docs.datadoghq.com/agent/kubernetes/dogstatsd/
  ## To emit custom metrics from your Kubernetes application, use DogStatsD.
  dogstatsd:
    # datadog.dogstatsd.port -- Override the Agent DogStatsD port

    ## Note: Make sure your client is sending to the same UDP port.
    port: 8125

    # datadog.dogstatsd.originDetection -- Enable origin detection for container tagging

    ## ref: https://docs.datadoghq.com/developers/dogstatsd/unix_socket/#using-origin-detection-for-container-tagging
    originDetection: false

    # datadog.dogstatsd.tags -- List of static tags to attach to every custom metric, event and service check collected by Dogstatsd.

    ## Learn more about tagging: https://docs.datadoghq.com/tagging/
    tags: []
    #   - "<KEY_1>:<VALUE_1>"
    #   - "<KEY_2>:<VALUE_2>"

    # datadog.dogstatsd.tagCardinality -- Sets the tag cardinality relative to the origin detection

    ## ref: https://docs.datadoghq.com/developers/dogstatsd/unix_socket/#using-origin-detection-for-container-tagging
    tagCardinality: low

    # datadog.dogstatsd.useSocketVolume -- Enable dogstatsd over Unix Domain Socket with an HostVolume

    ## ref: https://docs.datadoghq.com/developers/dogstatsd/unix_socket/
    useSocketVolume: true

    # datadog.dogstatsd.socketPath -- Path to the DogStatsD socket
    socketPath: /var/run/datadog/dsd.socket

    # datadog.dogstatsd.hostSocketPath -- Host path to the DogStatsD socket
    hostSocketPath: /var/run/datadog/

    # datadog.dogstatsd.useHostPort -- Sets the hostPort to the same value of the container port

    ## Needs to be used for sending custom metrics.
    ## The ports need to be available on all hosts.
    ##
    ## WARNING: Make sure that hosts using this are properly firewalled otherwise
    ## metrics and traces are accepted from any host able to connect to this host.
    useHostPort: false

    # datadog.dogstatsd.useHostPID -- Run the agent in the host's PID namespace
    ## DEPRECATED: use datadog.useHostPID instead.

    ## This is required for Dogstatsd origin detection to work.
    ## See https://docs.datadoghq.com/developers/dogstatsd/unix_socket/
    useHostPID: false

    # datadog.dogstatsd.nonLocalTraffic -- Enable this to make each node accept non-local statsd traffic (from outside of the pod)

    ## ref: https://github.com/DataDog/docker-dd-agent#environment-variables
    nonLocalTraffic: true

  # datadog.useHostPID -- Run the agent in the host's PID namespace, required for origin detection
  # / unified service tagging
  ## This is required for Dogstatsd origin detection to work in dogstatsd and trace agent
  ## See https://docs.datadoghq.com/developers/dogstatsd/unix_socket/
  useHostPID: true
  # datadog.collectEvents -- Enables this to start event collection from the kubernetes API
  ## ref: https://docs.datadoghq.com/agent/kubernetes/#event-collection
  collectEvents: true
  # datadog.leaderElection -- Enables leader election mechanism for event collection
  leaderElection: true
  # datadog.leaderLeaseDuration -- Set the lease time for leader election in second
  leaderLeaseDuration:  # 60
####################################### LOGS CONFIGURATION #######################################

  ## Enable logs agent and provide custom configs
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

  ## Enable apm agent and provide custom configs
  apm:
    # datadog.apm.socketEnabled -- Enable APM over Socket (Unix Socket or windows named pipe)

    ## ref: https://docs.datadoghq.com/agent/kubernetes/apm/
    socketEnabled: false

    # datadog.apm.portEnabled -- Enable APM over TCP communication (port 8126 by default)

    ## ref: https://docs.datadoghq.com/agent/kubernetes/apm/
    portEnabled: false

    # datadog.apm.enabled -- Enable this to enable APM and tracing, on port 8126
    # DEPRECATED. Use datadog.apm.portEnabled instead

    ## ref: https://github.com/DataDog/docker-dd-agent#tracing-from-the-host
    enabled: false

    # datadog.apm.port -- Override the trace Agent port

    ## Note: Make sure your client is sending to the same UDP port.
    port: 8126

    # datadog.apm.useSocketVolume -- Enable APM over Unix Domain Socket
    # DEPRECATED. Use datadog.apm.socketEnabled instead

    ## ref: https://docs.datadoghq.com/agent/kubernetes/apm/
    useSocketVolume: false

    # datadog.apm.socketPath -- Path to the trace-agent socket
    socketPath: /var/run/datadog/apm.socket

    # datadog.apm.hostSocketPath -- Host path to the trace-agent socket
    hostSocketPath: /var/run/datadog/
####################################### otlp CONFIGURATION #######################################
  ## OTLP ingest related configuration
  otlp:
    receiver:
      protocols:
        # datadog.otlp.receiver.protocols.grpc - OTLP/gRPC configuration
        grpc:
          # datadog.otlp.receiver.protocols.grpc.enabled -- Enable the OTLP/gRPC endpoint
          enabled: false
          # datadog.otlp.receiver.procotols.grpc.endpoint -- OTLP/gRPC endpoint
          endpoint: "0.0.0.0:4317"
          # datadog.otlp.receiver.protocols.grpc.useHostPort -- Enable the Host Port for the OTLP/gRPC endpoint
          useHostPort: true

        # datadog.otlp.receiver.protocols.http - OTLP/HTTP configuration
        http:
          # datadog.otlp.receiver.protocols.http.enabled -- Enable the OTLP/HTTP endpoint
          enabled: false
          # datadog.otlp.receiver.protocols.http.endpoint -- OTLP/HTTP endpoint
          endpoint: "0.0.0.0:4318"
          # datadog.otlp.receiver.protocols.http.useHostPort -- Enable the Host Port for the OTLP/HTTP endpoint
          useHostPort: true

  # datadog.envFrom -- Set environment variables for all Agents directly from configMaps and/or secrets

  ## envFrom to pass configmaps or secrets as environment
  envFrom: []
  #   - configMapRef:
  #       name: <CONFIGMAP_NAME>
  #   - secretRef:
  #       name: <SECRET_NAME>

  # datadog.env -- Set environment variables for all Agents

  ## The Datadog Agent supports many environment variables.
  ## ref: https://docs.datadoghq.com/agent/docker/?tab=standard#environment-variables
  env: []
  #   - name: <ENV_VAR_NAME>
  #     value: <ENV_VAR_VALUE>

  # datadog.confd -- Provide additional check configurations (static and Autodiscovery)

  ## Each key becomes a file in /conf.d
  ## ref: https://github.com/DataDog/datadog-agent/tree/main/Dockerfiles/agent#optional-volumes
  ## ref: https://docs.datadoghq.com/agent/autodiscovery/
  confd: {}
  #   redisdb.yaml: |-
  #     init_config:
  #     instances:
  #       - host: "name"
  #         port: "6379"
  #   kubernetes_state.yaml: |-
  #     ad_identifiers:
  #       - kube-state-metrics
  #     init_config:
  #     instances:
  #       - kube_state_url: http://%%host%%:8080/metrics

  # datadog.checksd -- Provide additional custom checks as python code

  ## Each key becomes a file in /checks.d
  ## ref: https://github.com/DataDog/datadog-agent/tree/main/Dockerfiles/agent#optional-volumes
  checksd: {}
  #   service.py: |-

  # datadog.dockerSocketPath -- Path to the docker socket
  dockerSocketPath:  # /var/run/docker.sock

  # datadog.criSocketPath -- Path to the container runtime socket (if different from Docker)
  criSocketPath:  # /var/run/containerd/containerd.sock

  # Configure how the agent interact with the host's container runtime
  containerRuntimeSupport:
    # datadog.containerRuntimeSupport.enabled -- Set this to false to disable agent access to container runtime.
    enabled: true

####################################### PROCESS AGENT CONFIGURATION #######################################
  processAgent:
    enabled: true
    processCollection: true
    stripProcessArguments: true
    processDiscovery: true
  osReleasePath: /etc/os-release

  ## Enable systemProbe agent and provide custom configs
  systemProbe:

    # datadog.systemProbe.debugPort -- Specify the port to expose pprof and expvar for system-probe agent
    debugPort: 0

    # datadog.systemProbe.enableConntrack -- Enable the system-probe agent to connect to the netlink/conntrack subsystem to add NAT information to connection data

    ## ref: http://conntrack-tools.netfilter.org/
    enableConntrack: true

    # datadog.systemProbe.seccomp -- Apply an ad-hoc seccomp profile to the system-probe agent to restrict its privileges

    ## Note that this will break `kubectl exec … -c system-probe -- /bin/bash`
    seccomp: localhost/system-probe

    # datadog.systemProbe.seccompRoot -- Specify the seccomp profile root directory
    seccompRoot: /var/lib/kubelet/seccomp

    # datadog.systemProbe.bpfDebug -- Enable logging for kernel debug
    bpfDebug: false

    # datadog.systemProbe.apparmor -- Specify a apparmor profile for system-probe
    apparmor: unconfined

    # datadog.systemProbe.enableTCPQueueLength -- Enable the TCP queue length eBPF-based check
    enableTCPQueueLength: false

    # datadog.systemProbe.enableOOMKill -- Enable the OOM kill eBPF-based check
    enableOOMKill: false

    # datadog.systemProbe.enableRuntimeCompiler -- Enable the runtime compiler for eBPF probes
    enableRuntimeCompiler: false

    # datadog.systemProbe.enableKernelHeaderDownload -- Enable the downloading of kernel headers for runtime compilation of eBPF probes
    enableKernelHeaderDownload: true

    # datadog.systemProbe.mountPackageManagementDirs -- Enables mounting of specific package management directories when runtime compilation is enabled
    mountPackageManagementDirs: []
    ## For runtime compilation to be able to download kernel headers, the host's package management folders
    ## must be mounted to the /host directory. For example, for Ubuntu & Debian the following mount would be necessary:
    # - name: "apt-config-dir"
    #   hostPath: /etc/apt
    #   mountPath: /host/etc/apt
    ## If this list is empty, then all necessary package management directories (for all supported OSs) will be mounted.

    # datadog.systemProbe.runtimeCompilationAssetDir -- Specify a directory for runtime compilation assets to live in
    runtimeCompilationAssetDir: /var/tmp/datadog-agent/system-probe

    # datadog.systemProbe.collectDNSStats -- Enable DNS stat collection
    collectDNSStats: true

    # datadog.systemProbe.maxTrackedConnections -- the maximum number of tracked connections
    maxTrackedConnections: 131072

    # datadog.systemProbe.conntrackMaxStateSize -- the maximum size of the userspace conntrack cache
    conntrackMaxStateSize: 131072  # 2 * maxTrackedConnections by default, per  https://github.com/DataDog/datadog-agent/blob/d1c5de31e1bba72dfac459aed5ff9562c3fdcc20/pkg/process/config/config.go#L229

    # datadog.systemProbe.conntrackInitTimeout -- the time to wait for conntrack to initialize before failing
    conntrackInitTimeout: 10s

    # datadog.systemProbe.enableDefaultOsReleasePaths -- enable default os-release files mount
    enableDefaultOsReleasePaths: true

    # datadog.systemProbe.enableDefaultKernelHeadersPaths -- Enable mount of default paths where kernel headers are stored
    enableDefaultKernelHeadersPaths: true
####################################### orchestratorExplorer CONFIGURATION #######################################
  orchestratorExplorer:
    enabled: true
    container_scrubbing:
      enabled: true
###
# Cool Option:
###
  helmCheck:
    # datadog.helmCheck.enabled -- Set this to true to enable the Helm check (Requires Agent 7.35.0+ and Cluster Agent 1.19.0+)
    # This requires clusterAgent.enabled to be set to true
    enabled: false
    # datadog.helmCheck.collectEvents -- Set this to true to enable event collection in the Helm Check (Requires Agent 7.36.0+ and Cluster Agent 1.20.0+)
    # This requires datadog.HelmCheck.enabled to be set to true
    collectEvents: false
    # datadog.helmCheck.valuesAsTags -- Collects Helm values from a release and uses them as tags (Requires Agent and Cluster Agent 7.40.0+).
    # This requires datadog.HelmCheck.enabled to be set to true
    valuesAsTags: {}
      #   <HELM_VALUE>: <LABEL_NAME>
####################################### Network Monitoring CONFIGURATION #######################################
  networkMonitoring:
    enabled: false
  ## Universal Service Monitoring is currently in private beta.
  ## See https://www.datadoghq.com/blog/universal-service-monitoring-datadog/ for more details and private beta signup.
  serviceMonitoring:
    # datadog.serviceMonitoring.enabled -- Enable Universal Service Monitoring
    enabled: false
  ## Enable security agent and provide custom configs
####################################### Security Monitoting CONFIGURATION #######################################
  securityAgent:
    compliance:
      # datadog.securityAgent.compliance.enabled -- Set to true to enable Cloud Security Posture Management (CSPM)
      enabled: false
      # datadog.securityAgent.compliance.configMap -- Contains CSPM compliance benchmarks that will be used
      configMap:
      # datadog.securityAgent.compliance.checkInterval -- Compliance check run interval
      checkInterval: 20m
    runtime:
      # datadog.securityAgent.runtime.enabled -- Set to true to enable Cloud Workload Security (CWS)
      enabled: false
      # datadog.securityAgent.runtime.fimEnabled -- Set to true to enable Cloud Workload Security (CWS) File Integrity Monitoring
      fimEnabled: false
      policies:
        # datadog.securityAgent.runtime.policies.configMap -- Contains CWS policies that will be used
        configMap:
      syscallMonitor:
        # datadog.securityAgent.runtime.syscallMonitor.enabled -- Set to true to enable the Syscall monitoring (recommended for troubleshooting only)
        enabled: false
      network:
        # datadog.securityAgent.runtime.network.enabled -- Set to true to enable the collection of CWS network events
        enabled: false

      activityDump:
        # datadog.securityAgent.runtime.activityDump.enabled -- Set to true to enable the collection of CWS activity dumps
        enabled: false

        # datadog.securityAgent.runtime.activityDump.tracedCgroupsCount -- Set to the number of containers that should be traced concurrently
        tracedCgroupsCount: 3

        # datadog.securityAgent.runtime.activityDump.cgroupDumpTimeout -- Set to the desired duration of a single container tracing (in minutes)
        cgroupDumpTimeout: 20

        # datadog.securityAgent.runtime.activityDump.cgroupWaitListSize -- Set to the size of the wait list for already traced containers
        cgroupWaitListSize: 0

        pathMerge:
          # datadog.securityAgent.runtime.activityDump.pathMerge.enabled -- Set to true to enable the merging of similar paths
          enabled: false

  ## Manage NetworkPolicy
  networkPolicy:
    # datadog.networkPolicy.create -- If true, create NetworkPolicy for all the components
    create: false

    # datadog.networkPolicy.flavor -- Flavor of the network policy to use.
    # Can be:
    # * kubernetes for networking.k8s.io/v1/NetworkPolicy
    # * cilium     for cilium.io/v2/CiliumNetworkPolicy
    flavor: kubernetes

    cilium:
      # datadog.networkPolicy.cilium.dnsSelector -- Cilium selector of the DNS server entity
      # @default -- kube-dns in namespace kube-system
      dnsSelector:
        toEndpoints:
          - matchLabels:
              "k8s:io.kubernetes.pod.namespace": kube-system
              "k8s:k8s-app": kube-dns

  ## Configure prometheus scraping autodiscovery
####################################### prometheusScrape CONFIGURATION #######################################
  ## ref: https://docs.datadoghq.com/agent/kubernetes/prometheus/
  prometheusScrape:
    # datadog.prometheusScrape.enabled -- Enable autodiscovering pods and services exposing prometheus metrics.
    enabled: false
    # datadog.prometheusScrape.serviceEndpoints -- Enable generating dedicated checks for service endpoints.
    serviceEndpoints: false
    # datadog.prometheusScrape.additionalConfigs -- Allows adding advanced openmetrics check configurations with custom discovery rules. (Requires Agent version 7.27+)
    additionalConfigs: []
      # -
      #   autodiscovery:
      #     kubernetes_annotations:
      #       include:
      #         custom_include_label: 'true'
      #       exclude:
      #         custom_exclude_label: 'true'
      #     kubernetes_container_names:
      #     - my-app
      #   configurations:
      #   - send_distribution_buckets: true
      #     timeout: 5
    # datadog.prometheusScrape.version -- Version of the openmetrics check to schedule by default.

    # See https://datadoghq.dev/integrations-core/legacy/prometheus/#config-changes-between-versions for the differences between the two versions.
    # (Version 2 requires Agent version 7.34+)
    version: 2

  # datadog.ignoreAutoConfig -- List of integration to ignore auto_conf.yaml.

  ## ref: https://docs.datadoghq.com/agent/faq/auto_conf/
  ignoreAutoConfig: []
  #  - redisdb
  #  - kubernetes_state

  # datadog.containerExclude -- Exclude containers from the Agent
  # Autodiscovery, as a space-sepatered list

  ## ref: https://docs.datadoghq.com/agent/guide/autodiscovery-management/?tab=containerizedagent#exclude-containers
  containerExclude:  # "image:datadog/agent"

  # datadog.containerInclude -- Include containers in the Agent Autodiscovery,
  # as a space-separated list.  If a container matches an include rule, it’s
  # always included in the Autodiscovery

  ## ref: https://docs.datadoghq.com/agent/guide/autodiscovery-management/?tab=containerizedagent#include-containers
  containerInclude:

  # datadog.containerExcludeLogs -- Exclude logs from the Agent Autodiscovery,
  # as a space-separated list
  containerExcludeLogs:

  # datadog.containerIncludeLogs -- Include logs in the Agent Autodiscovery, as
  # a space-separated list
  containerIncludeLogs:

  # datadog.containerExcludeMetrics -- Exclude metrics from the Agent
  # Autodiscovery, as a space-separated list
  containerExcludeMetrics:

  # datadog.containerIncludeMetrics -- Include metrics in the Agent
  # Autodiscovery, as a space-separated list
  containerIncludeMetrics:

  # datadog.excludePauseContainer -- Exclude pause containers from the Agent Autodiscovery.

  ## ref: https://docs.datadoghq.com/agent/guide/autodiscovery-management/?tab=containerizedagent#pause-containers
  excludePauseContainer: true

####################################### CLUSTER AGENT CONFIGURATION #######################################
clusterAgent:
  # clusterAgent.enabled -- Set this to false to disable Datadog Cluster Agent
  enabled: true
  # clusterAgent.shareProcessNamespace -- Set the process namespace sharing on the Datadog Cluster Agent
  shareProcessNamespace: false

  ## Define the Datadog Cluster-Agent image to work with
  image:
    name: cluster-agent
    tag: 7.40.1
    digest: ""
    repository:
    pullPolicy: IfNotPresent
    ## See https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod
    pullSecrets: []
    #   - name: "<REG_SECRET>"
    # clusterAgent.image.doNotCheckTag -- Skip the version and chart compatibility check
    ## By default, the version passed in clusterAgent.image.tag is checked
    ## for compatibility with the version of the chart.
    ## This boolean permits completely skipping this check.
    ## This is useful, for example, for custom tags that are not
    ## respecting semantic versioning.
    doNotCheckTag:  # false
  # clusterAgent.securityContext -- Allows you to overwrite the default PodSecurityContext on the cluster-agent pods.
  securityContext: {}
  containers:
    clusterAgent:
      # clusterAgent.containers.clusterAgent.securityContext -- Specify securityContext on the cluster-agent container.
      securityContext: {}

  # clusterAgent.command -- Command to run in the Cluster Agent container as entrypoint
  command: []

  # clusterAgent.token -- Cluster Agent token is a preshared key between node agents and cluster agent (autogenerated if empty, needs to be at least 32 characters a-zA-z)
  token: ""

  # clusterAgent.tokenExistingSecret -- Existing secret name to use for Cluster Agent token. Put the Cluster Agent token in a key named `token` inside the Secret
  tokenExistingSecret: ""

  # clusterAgent.replicas -- Specify the of cluster agent replicas, if > 1 it allow the cluster agent to work in HA mode.
  replicas: 1

  # clusterAgent.revisionHistoryLimit -- The number of old ReplicaSets to keep in this Deployment.
  revisionHistoryLimit: 10

  ## Provide Cluster Agent Deployment pod(s) RBAC configuration
  rbac:
    # clusterAgent.rbac.create -- If true, create & use RBAC resources
    create: true

    # clusterAgent.rbac.serviceAccountName -- Specify a preexisting ServiceAccount to use if clusterAgent.rbac.create is false
    serviceAccountName: default

    # clusterAgent.rbac.serviceAccountAnnotations -- Annotations to add to the ServiceAccount if clusterAgent.rbac.create is true
    serviceAccountAnnotations: {}

  ## Provide Cluster Agent pod security configuration
  podSecurity:
    podSecurityPolicy:
      # clusterAgent.podSecurity.podSecurityPolicy.create -- If true, create a PodSecurityPolicy resource for Cluster Agent pods
      create: false
    securityContextConstraints:
      # clusterAgent.podSecurity.securityContextConstraints.create -- If true, create a SCC resource for Cluster Agent pods
      create: false

  # Enable the metricsProvider to be able to scale based on metrics in Datadog
  metricsProvider:
    # clusterAgent.metricsProvider.enabled -- Set this to true to enable Metrics Provider
    enabled: true
    # clusterAgent.metricsProvider.wpaController -- Enable informer and controller of the watermark pod autoscaler
    ## Note: You need to install the `WatermarkPodAutoscaler` CRD before
    wpaController: false
    # clusterAgent.metricsProvider.useDatadogMetrics -- Enable usage of DatadogMetric CRD to autoscale on arbitrary Datadog queries
    ## Note: It will install DatadogMetrics CRD automatically (it may conflict with previous installations)
    useDatadogMetrics: false
    # clusterAgent.metricsProvider.createReaderRbac -- Create `external-metrics-reader` RBAC automatically (to allow HPA to read data from Cluster Agent)
    createReaderRbac: true
    # clusterAgent.metricsProvider.aggregator -- Define the aggregator the cluster agent will use to process the metrics. The options are (avg, min, max, sum)
    aggregator: avg
    ## Configuration for the service for the cluster-agent metrics server
####### SERVICES
    service:
      # clusterAgent.metricsProvider.service.type -- Set type of cluster-agent metrics server service
      type: ClusterIP
      # clusterAgent.metricsProvider.service.port -- Set port of cluster-agent metrics server service (Kubernetes >= 1.15)
      port: 8443
    # clusterAgent.metricsProvider.endpoint -- Override the external metrics provider endpoint. If not set, the cluster-agent defaults to `datadog.site`
    endpoint:  # https://api.datadoghq.com

  # clusterAgent.env -- Set environment variables specific to Cluster Agent

  ## The Cluster-Agent supports many additional environment variables
  ## ref: https://docs.datadoghq.com/agent/cluster_agent/commands/#cluster-agent-options
  #env: []

  # clusterAgent.envFrom --  Set environment variables specific to Cluster Agent from configMaps and/or secrets

  ## The Cluster-Agent supports many additional environment variables
  ## ref: https://docs.datadoghq.com/agent/cluster_agent/commands/#cluster-agent-options
  #envFrom: []
  #   - configMapRef:
  #       name: <CONFIGMAP_NAME>
  #   - secretRef:
  #       name: <SECRET_NAME>
####################################### SERVICE Admission Controller CONFIGURATION #######################################
  admissionController:
    # clusterAgent.admissionController.enabled -- Enable the admissionController to be able to inject APM/Dogstatsd config and standard tags (env, service, version) automatically into your pods
    enabled: true
    # clusterAgent.admissionController.mutateUnlabelled -- Enable injecting config without having the pod label 'admission.datadoghq.com/enabled="true"'
    mutateUnlabelled: true
    # clusterAgent.admissionController.configMode -- The kind of configuration to be injected, it can be "hostip", "service", or "socket".
    ## If clusterAgent.admissionController.configMode is not set, the Admission Controller defaults to hostip.
    ## Note: "service" mode relies on the internal traffic service to target the agent running on the local node (requires Kubernetes v1.22+).
    ## ref: https://docs.datadoghq.com/agent/cluster_agent/admission_controller/#configure-apm-and-dogstatsd-communication-mode
    configMode:  # "hostip", "socket" or "service"
    # clusterAgent.admissionController.failurePolicy -- Set the failure policy for dynamic admission control.'
    ## The default of Ignore means that pods will still be admitted even if the webhook is unavailable to inject them.
    ## Setting to Fail will require the admission controller to be present and pods to be injected before they are allowed to run.
    failurePolicy: Ignore
  # clusterAgent.confd -- Provide additional cluster check configurations. Each key will become a file in /conf.d.
  ## ref: https://docs.datadoghq.com/agent/autodiscovery/
  #confd: {}
  #   mysql.yaml: |-
  #     cluster_check: true
  #     instances:
  #       - host: <EXTERNAL_IP>
  #         port: 3306
  #         username: datadog
  #         password: <YOUR_CHOSEN_PASSWORD>

  # clusterAgent.advancedConfd -- Provide additional cluster check configurations. Each key is an integration containing several config files.

  ## ref: https://docs.datadoghq.com/agent/autodiscovery/
  #advancedConfd: {}
  #  mysql.d:
  #    1.yaml: |-
  #      cluster_check: true
  #      instances:
  #        - host: <EXTERNAL_IP>
  #          port: 3306
  #          username: datadog
  #          password: <YOUR_CHOSEN_PASSWORD>
  #    2.yaml:  |-
  #      cluster_check: true
  #      instances:
  #        - host: <EXTERNAL_IP>
  #          port: 3306
  #          username: datadog
  #          password: <YOUR_CHOSEN_PASSWORD>
  # clusterAgent.resources -- Datadog cluster-agent resource requests and limits.
  resources:
    requests:
      cpu: 200m
      memory: 256Mi
    limits:
      cpu: 200m
      memory: 256Mi

  # clusterAgent.priorityClassName -- Name of the priorityClass to apply to the Cluster Agent
  priorityClassName:  # system-cluster-critical

  # clusterAgent.nodeSelector -- Allow the Cluster Agent Deployment to be scheduled on selected nodes

  ## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector
  ## Ref: https://kubernetes.io/docs/user-guide/node-selection/
  nodeSelector: {}

  # clusterAgent.tolerations -- Allow the Cluster Agent Deployment to schedule on tainted nodes ((requires Kubernetes >= 1.6))

  ## Ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  tolerations: []

  # clusterAgent.affinity -- Allow the Cluster Agent Deployment to schedule using affinity rules

  ## By default, Cluster Agent Deployment Pods are forced to run on different Nodes.
  ## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  affinity: {}

  # clusterAgent.healthPort -- Port number to use in the Cluster Agent for the healthz endpoint
  healthPort: 5556

  # clusterAgent.livenessProbe -- Override default Cluster Agent liveness probe settings
  # @default -- Every 15s / 6 KO / 1 OK
  livenessProbe:
    initialDelaySeconds: 15
    periodSeconds: 15
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 6

  # clusterAgent.readinessProbe -- Override default Cluster Agent readiness probe settings
  # @default -- Every 15s / 6 KO / 1 OK
  readinessProbe:
    initialDelaySeconds: 15
    periodSeconds: 15
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 6

  # clusterAgent.strategy -- Allow the Cluster Agent deployment to perform a rolling update on helm update

  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0

  # clusterAgent.deploymentAnnotations -- Annotations to add to the cluster-agents's deployment
  deploymentAnnotations: {}
  #   key: "value"

  # clusterAgent.podAnnotations -- Annotations to add to the cluster-agents's pod(s)
  podAnnotations: {}
  #   key: "value"

  # clusterAgent.useHostNetwork -- Bind ports on the hostNetwork

  ## Useful for CNI networking where hostPort might
  ## not be supported. The ports need to be available on all hosts. It can be
  ## used for custom metrics instead of a service endpoint.
  ##
  ## WARNING: Make sure that hosts using this are properly firewalled otherwise
  ## metrics and traces are accepted from any host able to connect to this host.
  #
  useHostNetwork: false

  # clusterAgent.dnsConfig -- Specify dns configuration options for datadog cluster agent containers e.g ndots

  ## ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-dns-config
  dnsConfig: {}
  #  options:
  #  - name: ndots
  #    value: "1"

  # clusterAgent.volumes -- Specify additional volumes to mount in the cluster-agent container
  volumes: []
  #   - hostPath:
  #       path: <HOST_PATH>
  #     name: <VOLUME_NAME>

  # clusterAgent.volumeMounts -- Specify additional volumes to mount in the cluster-agent container
  volumeMounts: []
  #   - name: <VOLUME_NAME>
  #     mountPath: <CONTAINER_PATH>
  #     readOnly: true
#### EXPLORE
  # clusterAgent.datadog_cluster_yaml -- Specify custom contents for the datadog cluster agent config (datadog-cluster.yaml)
  datadog_cluster_yaml: {}

  # clusterAgent.createPodDisruptionBudget -- Create pod disruption budget for Cluster Agent deployments
  createPodDisruptionBudget: false

  networkPolicy:
    # clusterAgent.networkPolicy.create -- If true, create a NetworkPolicy for the cluster agent.
    # DEPRECATED. Use datadog.networkPolicy.create instead
    create: false

  # clusterAgent.additionalLabels -- Adds labels to the Cluster Agent deployment and pods
  additionalLabels: {}
    # key: "value"

## This section lets you configure the agents deployed by this chart to connect to a Cluster Agent
## deployed independently
existingClusterAgent:
  # existingClusterAgent.join -- set this to true if you want the agents deployed by this chart to
  # connect to a Cluster Agent deployed independently
  join: false
  # existingClusterAgent.tokenSecretName -- Existing secret name to use for external Cluster Agent token
  tokenSecretName:  # <EXISTING_DCA_SECRET_NAME>
  # existingClusterAgent.serviceName -- Existing service name to use for reaching the external Cluster Agent
  serviceName:  # <EXISTING_DCA_SERVICE_NAME>
  # existingClusterAgent.clusterchecksEnabled -- set this to false if you don’t want the agents to run the cluster checks of the joined external cluster agent
  clusterchecksEnabled: true
####################################### AGENT CONFIGURATION #######################################
agents:
  # agents.enabled -- You should keep Datadog DaemonSet enabled!

  ## The exceptional case could be a situation when you need to run
  ## single Datadog pod per every namespace, but you do not need to
  ## re-create a DaemonSet for every non-default namespace install.
  ## Note: StatsD and DogStatsD work over UDP, so you may not
  ## get guaranteed delivery of the metrics in Datadog-per-namespace setup!
  enabled: true

  # agents.shareProcessNamespace -- Set the process namespace sharing on the Datadog Daemonset
  shareProcessNamespace: false

  # agents.revisionHistoryLimit -- The number of ControllerRevision to keep in this DaemonSet.
  revisionHistoryLimit: 10

  ## Define the Datadog image to work with
  image:
    # agents.image.name -- Datadog Agent image name to use (relative to `registry`)

    ## use "dogstatsd" for Standalone Datadog Agent DogStatsD 7
    name: agent

    # agents.image.tag -- Define the Agent version to use
    tag: 7.40.1

    # agents.image.digest -- Define Agent image digest to use, takes precedence over tag if specified
    digest: ""

    # agents.image.tagSuffix -- Suffix to append to Agent tag

    ## Ex:
    ##  jmx        to enable jmx fetch collection
    ##  servercore to get Windows images based on servercore
    tagSuffix: ""

    # agents.image.repository -- Override default registry + image.name for Agent
    repository:

    # agents.image.doNotCheckTag -- Skip the version and chart compatibility check

    ## By default, the version passed in agents.image.tag is checked
    ## for compatibility with the version of the chart.
    ## This boolean permits to completely skip this check.
    ## This is useful, for example, for custom tags that are not
    ## respecting semantic versioning
    doNotCheckTag:  # false

    # agents.image.pullPolicy -- Datadog Agent image pull policy
    pullPolicy: IfNotPresent

    # agents.image.pullSecrets -- Datadog Agent repository pullSecret (ex: specify docker registry credentials)

    ## See https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod
    pullSecrets: []
    #   - name: "<REG_SECRET>"

  ## Provide Daemonset RBAC configuration
  rbac:
    # agents.rbac.create -- If true, create & use RBAC resources
    create: true

    # agents.rbac.serviceAccountName -- Specify a preexisting ServiceAccount to use if agents.rbac.create is false
    serviceAccountName: default

    # agents.rbac.serviceAccountAnnotations -- Annotations to add to the ServiceAccount if agents.rbac.create is true
    serviceAccountAnnotations: {}

  ## Provide Daemonset PodSecurityPolicy configuration
  podSecurity:
    podSecurityPolicy:
      # agents.podSecurity.podSecurityPolicy.create -- If true, create a PodSecurityPolicy resource for Agent pods
      create: false

    securityContextConstraints:
      # agents.podSecurity.securityContextConstraints.create -- If true, create a SecurityContextConstraints resource for Agent pods
      create: false

    # agents.podSecurity.seLinuxContext -- Provide seLinuxContext configuration for PSP/SCC
    # @default -- Must run as spc_t
    seLinuxContext:
      rule: MustRunAs
      seLinuxOptions:
        user: system_u
        role: system_r
        type: spc_t
        level: s0

    # agents.podSecurity.privileged -- If true, Allow to run privileged containers
    privileged: false

    # agents.podSecurity.capabilities -- Allowed capabilities

    ## note: capabilities must contain all agents.containers.*.securityContext.capabilities.
    capabilities:
      - SYS_ADMIN
      - SYS_RESOURCE
      - SYS_PTRACE
      - NET_ADMIN
      - NET_BROADCAST
      - NET_RAW
      - IPC_LOCK
      - CHOWN
      - AUDIT_CONTROL
      - AUDIT_READ

    # agents.podSecurity.allowedUnsafeSysctls -- Allowed unsafe sysclts
    allowedUnsafeSysctls: []

    # agents.podSecurity.volumes -- Allowed volumes types
    volumes:
      - configMap
      - downwardAPI
      - emptyDir
      - hostPath
      - secret

    # agents.podSecurity.seccompProfiles -- Allowed seccomp profiles
    seccompProfiles:
      - "runtime/default"
      - "localhost/system-probe"

    apparmor:
      # agents.podSecurity.apparmor.enabled -- If true, enable apparmor enforcement

      ## see: https://kubernetes.io/docs/tutorials/clusters/apparmor/
      enabled: true

    # agents.podSecurity.apparmorProfiles -- Allowed apparmor profiles
    apparmorProfiles:
      - "runtime/default"
      - "unconfined"

    # agents.podSecurity.defaultApparmor -- Default AppArmor profile for all containers but system-probe
    defaultApparmor: runtime/default
####################################### Containers AGENT CONFIGURATION #######################################
  containers:
    agent:
      # agents.containers.agent.env -- Additional environment variables for the agent container
      env: []

      # agents.containers.agent.envFrom -- Set environment variables specific to agent container from configMaps and/or secrets
      envFrom: []
      #   - configMapRef:
      #       name: <CONFIGMAP_NAME>
      #   - secretRef:
      #       name: <SECRET_NAME>

      # agents.containers.agent.logLevel -- Set logging verbosity, valid log levels are: trace, debug, info, warn, error, critical, and off.
      # If not set, fall back to the value of datadog.logLevel.
      logLevel:  # INFO

      # agents.containers.agent.resources -- Resource requests and limits for the agent container.
      resources: {}
      #  requests:
      #    cpu: 200m
      #    memory: 256Mi
      #  limits:
      #    cpu: 200m
      #    memory: 256Mi

      # agents.containers.agent.healthPort -- Port number to use in the node agent for the healthz endpoint
      healthPort: 5555

      # agents.containers.agent.livenessProbe -- Override default agent liveness probe settings
      # @default -- Every 15s / 6 KO / 1 OK
      livenessProbe:
        initialDelaySeconds: 15
        periodSeconds: 15
        timeoutSeconds: 5
        successThreshold: 1
        failureThreshold: 6

      # agents.containers.agent.readinessProbe -- Override default agent readiness probe settings
      # @default -- Every 15s / 6 KO / 1 OK
      readinessProbe:
        initialDelaySeconds: 15
        periodSeconds: 15
        timeoutSeconds: 5
        successThreshold: 1
        failureThreshold: 6

      # agents.containers.agent.securityContext -- Allows you to overwrite the default container SecurityContext for the agent container.
      securityContext: {}

      # agents.containers.agent.ports -- Allows to specify extra ports (hostPorts for instance) for this container
      ports: []

    processAgent:
      # agents.containers.processAgent.env -- Additional environment variables for the process-agent container
      env: []

      # agents.containers.processAgent.envFrom -- Set environment variables specific to process-agent from configMaps and/or secrets
      envFrom: []
      #   - configMapRef:
      #       name: <CONFIGMAP_NAME>
      #   - secretRef:
      #       name: <SECRET_NAME>

      # agents.containers.processAgent.logLevel -- Set logging verbosity, valid log levels are: trace, debug, info, warn, error, critical, and off.
      # If not set, fall back to the value of datadog.logLevel.
      logLevel:  # INFO

      # agents.containers.processAgent.resources -- Resource requests and limits for the process-agent container
      resources: {}
      #  requests:
      #    cpu: 100m
      #    memory: 200Mi
      #  limits:
      #    cpu: 100m
      #    memory: 200Mi

      # agents.containers.processAgent.securityContext -- Allows you to overwrite the default container SecurityContext for the process-agent container.
      securityContext: {}

      # agents.containers.processAgent.ports -- Allows to specify extra ports (hostPorts for instance) for this container
      ports: []

    traceAgent:
      env:
      logLevel:  # INFO
      resources: {}
      #  requests:
      #    cpu: 100m
      #    memory: 200Mi
      #  limits:
      #    cpu: 100m
      #    memory: 200Mi

      # agents.containers.traceAgent.livenessProbe -- Override default agent liveness probe settings
      # @default -- Every 15s
      livenessProbe:
        initialDelaySeconds: 15
        periodSeconds: 15
        timeoutSeconds: 5

      # agents.containers.traceAgent.securityContext -- Allows you to overwrite the default container SecurityContext for the trace-agent container.
      securityContext: {}

      # agents.containers.traceAgent.ports -- Allows to specify extra ports (hostPorts for instance) for this container
      ports: []

    systemProbe:
      # agents.containers.systemProbe.env -- Additional environment variables for the system-probe container
      env: []

      # agents.containers.systemProbe.envFrom -- Set environment variables specific to system-probe from configMaps and/or secrets
      envFrom: []
      #   - configMapRef:
      #       name: <CONFIGMAP_NAME>
      #   - secretRef:
      #       name: <SECRET_NAME>

      # agents.containers.systemProbe.logLevel -- Set logging verbosity, valid log levels are: trace, debug, info, warn, error, critical, and off.
      # If not set, fall back to the value of datadog.logLevel.
      logLevel:  # INFO

      # agents.containers.systemProbe.resources -- Resource requests and limits for the system-probe container
      resources: {}
      #  requests:
      #    cpu: 100m
      #    memory: 200Mi
      #  limits:
      #    cpu: 100m
      #    memory: 200Mi

      # agents.containers.systemProbe.securityContext -- Allows you to overwrite the default container SecurityContext for the system-probe container.

      ## agents.podSecurity.capabilities must reflect the changed made in securityContext.capabilities.
      securityContext:
        privileged: false
        capabilities:
          add: ["SYS_ADMIN", "SYS_RESOURCE", "SYS_PTRACE", "NET_ADMIN", "NET_BROADCAST", "NET_RAW", "IPC_LOCK", "CHOWN"]

      # agents.containers.systemProbe.ports -- Allows to specify extra ports (hostPorts for instance) for this container
      ports: []

    securityAgent:
      # agents.containers.securityAgent.env -- Additional environment variables for the security-agent container
      env:

      # agents.containers.securityAgent.envFrom -- Set environment variables specific to security-agent from configMaps and/or secrets
      envFrom: []
      #   - configMapRef:
      #       name: <CONFIGMAP_NAME>
      #   - secretRef:
      #       name: <SECRET_NAME>

      # agents.containers.securityAgent.logLevel -- Set logging verbosity, valid log levels are: trace, debug, info, warn, error, critical, and off.
      # If not set, fall back to the value of datadog.logLevel.
      logLevel:  # INFO

      # agents.containers.securityAgent.resources -- Resource requests and limits for the security-agent container
      resources: {}
      #  requests:
      #    cpu: 100m
      #    memory: 200Mi
      #  limits:
      #    cpu: 100m
      #    memory: 200Mi

      # agents.containers.securityAgent.ports -- Allows to specify extra ports (hostPorts for instance) for this container
      ports: []

    initContainers:
      # agents.containers.initContainers.resources -- Resource requests and limits for the init containers
      resources: {}
      #  requests:
      #    cpu: 100m
      #    memory: 200Mi
      #  limits:
      #    cpu: 100m
      #    memory: 200Mi

  # agents.volumes -- Specify additional volumes to mount in the dd-agent container
  volumes: []
  #   - hostPath:
  #       path: <HOST_PATH>
  #     name: <VOLUME_NAME>

  # agents.volumeMounts -- Specify additional volumes to mount in all containers of the agent pod
  volumeMounts: []
  #   - name: <VOLUME_NAME>
  #     mountPath: <CONTAINER_PATH>
  #     readOnly: true

  # agents.useHostNetwork -- Bind ports on the hostNetwork

  ## Useful for CNI networking where hostPort might
  ## not be supported. The ports need to be available on all hosts. It Can be
  ## used for custom metrics instead of a service endpoint.
  ##
  ## WARNING: Make sure that hosts using this are properly firewalled otherwise
  ## metrics and traces are accepted from any host able to connect to this host.
  useHostNetwork: false

  # agents.dnsConfig -- specify dns configuration options for datadog cluster agent containers e.g ndots

  ## ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-dns-config
  dnsConfig: {}
  #  options:
  #  - name: ndots
  #    value: "1"

  # agents.daemonsetAnnotations -- Annotations to add to the DaemonSet
  daemonsetAnnotations: {}
  #   key: "value"

  # agents.podAnnotations -- Annotations to add to the DaemonSet's Pods
  podAnnotations: {}
  #   key: "value"

  # agents.tolerations -- Allow the DaemonSet to schedule on tainted nodes (requires Kubernetes >= 1.6)
  tolerations: []

  # agents.nodeSelector -- Allow the DaemonSet to schedule on selected nodes

  ## Ref: https://kubernetes.io/docs/user-guide/node-selection/
  nodeSelector: {}

  # agents.affinity -- Allow the DaemonSet to schedule using affinity rules

  ## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  affinity: {}

  # agents.updateStrategy -- Allow the DaemonSet to perform a rolling update on helm update

  ## ref: https://kubernetes.io/docs/tasks/manage-daemon/update-daemon-set/
  updateStrategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: "10%"

  # agents.priorityClassCreate -- Creates a priorityClass for the Datadog Agent's Daemonset pods.
  priorityClassCreate: false

  # agents.priorityClassName -- Sets PriorityClassName if defined
  priorityClassName:

  # agents.priorityPreemptionPolicyValue -- Set to "Never" to change the PriorityClass to non-preempting
  priorityPreemptionPolicyValue: PreemptLowerPriority

  # agents.priorityClassValue -- Value used to specify the priority of the scheduling of Datadog Agent's Daemonset pods.

  ## The PriorityClass uses PreemptLowerPriority.
  priorityClassValue: 1000000000

  # agents.podLabels -- Sets podLabels if defined

  ## Note: These labels are also used as label selectors so they are immutable.
  podLabels: {}

  # agents.additionalLabels -- Adds labels to the Agent daemonset and pods
  additionalLabels: {}
    # key: "value"

  # agents.useConfigMap -- Configures a configmap to provide the agent configuration. Use this in combination with the `agents.customAgentConfig` parameter.
  useConfigMap:  # false

  # agents.customAgentConfig -- Specify custom contents for the datadog agent config (datadog.yaml)

  ## ref: https://docs.datadoghq.com/agent/guide/agent-configuration-files/?tab=agentv6
  ## ref: https://github.com/DataDog/datadog-agent/blob/main/pkg/config/config_template.yaml
  ## Note the `agents.useConfigMap` needs to be set to `true` for this parameter to be taken into account.
  customAgentConfig: {}
  #   # Autodiscovery for Kubernetes
  #   listeners:
  #     - name: kubelet
  #   config_providers:
  #     - name: kubelet
  #       polling: true
  #     # needed to support legacy docker label config templates
  #     - name: docker
  #       polling: true
  #
  #   # Enable java cgroup handling. Only one of those options should be enabled,
  #   # depending on the agent version you are using along that chart.
  #
  #   # agent version < 6.15
  #   # jmx_use_cgroup_memory_limit: true
  #
  #   # agent version >= 6.15
  #   # jmx_use_container_support: true

  networkPolicy:
    # agents.networkPolicy.create -- If true, create a NetworkPolicy for the agents.
    # DEPRECATED. Use datadog.networkPolicy.create instead
    create: false

  localService:
    # agents.localService.overrideName -- Name of the internal traffic service to target the agent running on the local node
    overrideName: ""

    # agents.localService.forceLocalServiceEnabled -- Force the creation of the internal traffic policy service to target the agent running on the local node.
    # By default, the internal traffic service is created only on Kubernetes 1.22+ where the feature became beta and enabled by default.
    # This option allows to force the creation of the internal traffic service on kubernetes 1.21 where the feature was alpha and required a feature gate to be explicitly enabled.
    forceLocalServiceEnabled: false

clusterChecksRunner:
  # clusterChecksRunner.enabled -- If true, deploys agent dedicated for running the Cluster Checks instead of running in the Daemonset's agents.

  ## ref: https://docs.datadoghq.com/agent/autodiscovery/clusterchecks/
  enabled: false

  ## Define the Datadog image to work with.
  image:
    # clusterChecksRunner.image.name -- Datadog Agent image name to use (relative to `registry`)
    name: agent

    # clusterChecksRunner.image.tag -- Define the Agent version to use
    tag: 7.40.1

    # clusterChecksRunner.image.digest -- Define Agent image digest to use, takes precedence over tag if specified
    digest: ""

    # clusterChecksRunner.image.tagSuffix -- Suffix to append to Agent tag

    ## Ex:
    ##  jmx        to enable jmx fetch collection
    ##  servercore to get Windows images based on servercore
    tagSuffix: ""

    # clusterChecksRunner.image.repository -- Override default registry + image.name for Cluster Check Runners
    repository:

    # clusterChecksRunner.image.pullPolicy -- Datadog Agent image pull policy
    pullPolicy: IfNotPresent

    # clusterChecksRunner.image.pullSecrets -- Datadog Agent repository pullSecret (ex: specify docker registry credentials)

    ## See https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod
    pullSecrets: []
    #   - name: "<REG_SECRET>"

  # clusterChecksRunner.createPodDisruptionBudget -- Create the pod disruption budget to apply to the cluster checks agents
  createPodDisruptionBudget: false

  # Provide Cluster Checks Deployment pods RBAC configuration
  rbac:
    # clusterChecksRunner.rbac.create -- If true, create & use RBAC resources
    create: true

    # clusterChecksRunner.rbac.dedicated -- If true, use a dedicated RBAC resource for the cluster checks agent(s)
    dedicated: false

    # clusterChecksRunner.rbac.serviceAccountAnnotations -- Annotations to add to the ServiceAccount if clusterChecksRunner.rbac.dedicated is true
    serviceAccountAnnotations: {}

    # clusterChecksRunner.rbac.serviceAccountName -- Specify a preexisting ServiceAccount to use if clusterChecksRunner.rbac.create is false
    serviceAccountName: default

  # clusterChecksRunner.replicas -- Number of Cluster Checks Runner instances

  ## If you want to deploy the clusterChecks agent in HA, keep at least clusterChecksRunner.replicas set to 2.
  ## And increase the clusterChecksRunner.replicas according to the number of Cluster Checks.
  replicas: 2

  # clusterChecksRunner.revisionHistoryLimit -- The number of old ReplicaSets to keep in this Deployment.
  revisionHistoryLimit: 10

  # clusterChecksRunner.resources -- Datadog clusterchecks-agent resource requests and limits.
  resources: {}
  # requests:
  #   cpu: 200m
  #   memory: 500Mi
  # limits:
  #   cpu: 200m
  #   memory: 500Mi

  # clusterChecksRunner.affinity -- Allow the ClusterChecks Deployment to schedule using affinity rules.

  ## By default, ClusterChecks Deployment Pods are preferred to run on different Nodes.
  ## Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity
  affinity: {}

  # clusterChecksRunner.strategy -- Allow the ClusterChecks deployment to perform a rolling update on helm update

  ## ref: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0

  # clusterChecksRunner.dnsConfig -- specify dns configuration options for datadog cluster agent containers e.g ndots

  ## ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-dns-config
  dnsConfig: {}
  #  options:
  #  - name: ndots
  #    value: "1"

  # clusterChecksRunner.priorityClassName -- Name of the priorityClass to apply to the Cluster checks runners
  priorityClassName:  # system-cluster-critical

  # clusterChecksRunner.nodeSelector -- Allow the ClusterChecks Deployment to schedule on selected nodes

  ## Ref: https://kubernetes.io/docs/user-guide/node-selection/
  nodeSelector: {}

  # clusterChecksRunner.tolerations -- Tolerations for pod assignment

  ## Ref: https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/
  tolerations: []

  # clusterChecksRunner.healthPort -- Port number to use in the Cluster Checks Runner for the healthz endpoint
  healthPort: 5557

  # clusterChecksRunner.livenessProbe -- Override default agent liveness probe settings
  # @default -- Every 15s / 6 KO / 1 OK

  ## In case of issues with the probe, you can disable it with the
  ## following values, to allow easier investigating:
  #
  # livenessProbe:
  #   exec:
  #     command: ["/bin/true"]
  #
  livenessProbe:
    initialDelaySeconds: 15
    periodSeconds: 15
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 6

  # clusterChecksRunner.readinessProbe -- Override default agent readiness probe settings
  # @default -- Every 15s / 6 KO / 1 OK

  ## In case of issues with the probe, you can disable it with the
  ## following values, to allow easier investigating:
  #
  # readinessProbe:
  #   exec:
  #     command: ["/bin/true"]
  #
  readinessProbe:
    initialDelaySeconds: 15
    periodSeconds: 15
    timeoutSeconds: 5
    successThreshold: 1
    failureThreshold: 6

  # clusterChecksRunner.deploymentAnnotations -- Annotations to add to the cluster-checks-runner's Deployment
  deploymentAnnotations: {}
  #   key: "value"

  # clusterChecksRunner.podAnnotations -- Annotations to add to the cluster-checks-runner's pod(s)
  podAnnotations: {}
  #   key: "value"

  # clusterChecksRunner.env -- Environment variables specific to Cluster Checks Runner

  ## ref: https://github.com/DataDog/datadog-agent/tree/main/Dockerfiles/agent#environment-variables
  env: []
  #   - name: <ENV_VAR_NAME>
  #     value: <ENV_VAR_VALUE>

  # clusterChecksRunner.envFrom -- Set environment variables specific to Cluster Checks Runner from configMaps and/or secrets

  ## envFrom to pass configmaps or secrets as environment
  ## ref: https://github.com/DataDog/datadog-agent/tree/main/Dockerfiles/agent#environment-variables
  envFrom: []
  #   - configMapRef:
  #       name: <CONFIGMAP_NAME>
  #   - secretRef:
  #       name: <SECRET_NAME>

  # clusterChecksRunner.volumes -- Specify additional volumes to mount in the cluster checks container
  volumes: []
  #   - hostPath:
  #       path: <HOST_PATH>
  #     name: <VOLUME_NAME>

  # clusterChecksRunner.volumeMounts -- Specify additional volumes to mount in the cluster checks container
  volumeMounts: []
  #   - name: <VOLUME_NAME>
  #     mountPath: <CONTAINER_PATH>
  #     readOnly: true

  networkPolicy:
    # clusterChecksRunner.networkPolicy.create -- If true, create a NetworkPolicy for the cluster checks runners.
    # DEPRECATED. Use datadog.networkPolicy.create instead
    create: false

  # clusterChecksRunner.additionalLabels -- Adds labels to the cluster checks runner deployment and pods
  additionalLabels: {}
    # key: "value"

  # clusterChecksRunner.securityContext -- Allows you to overwrite the default PodSecurityContext on the clusterchecks pods.
  securityContext: {}

  # clusterChecksRunner.ports -- Allows to specify extra ports (hostPorts for instance) for this container
  ports: []

datadog-crds:
  crds:
    datadogMetrics: true

kube-state-metrics:
  rbac:
    create: true
  serviceAccount:
    create: true
  resources:
    requests:
      cpu: 200m
      memory: 256Mi
    limits:
      cpu: 200m
      memory: 256Mi

  # kube-state-metrics.nodeSelector -- Node selector for KSM. KSM only supports Linux.
  nodeSelector:
    kubernetes.io/os: linux

  # # kube-state-metrics.image -- Override default image information for the kube-state-metrics container.
  # image:
  #  # kube-state-metrics.repository -- Override default image registry for the kube-state-metrics container.
  #  repository: k8s.gcr.io/kube-state-metrics/kube-state-metrics
  #  # kube-state-metrics.tag -- Override default image tag for the kube-state-metrics container.
  #  tag: v1.9.8
  #  # kube-state-metrics.pullPolicy -- Override default image pullPolicy for the kube-state-metrics container.
  #  pullPolicy: IfNotPresent
#providers:
#  eks:
#    ec2:
#      # providers.eks.ec2.useHostnameFromFile -- Use hostname from EC2 filesystem instead of fetching from metadata endpoint.
#      ## When deploying to EC2-backed EKS infrastructure, there are situations where the
#      ## IMDS metadata endpoint is not accesible to containers. This flag mounts the host's
#      ## `/var/lib/cloud/data/instance-id` and uses that for Agent's hostname instead.
#      useHostnameFromFile: false

