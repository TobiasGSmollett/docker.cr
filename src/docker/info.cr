module Docker
  class Info
    JSON.mapping({
      architecture: {key: "Architecture", nilable: true, type: String},
      containers: {key: "Containers", nilable: true, type: Int32},
      containers_running: {key: "ContainersRunning", nilable: true, type: Int32},
      containers_stopped: {key: "ContainersStopped", nilable: true, type: Int32},
      containers_paused: {key: "ContainersPaused", nilable: true, type: Int32},
      cpu_cfs_period: {key: "CpuCfsPeriod", nilable: true, type: Bool},
      cpu_cfs_quota: {key: "CpuCfsQuota", nilable: true, type: Bool},
      debug: {key: "Debug", nilable: true, type: Bool},
      discovery_backend: {key: "DiscoveryBackend", nilable: true, type: String},
      docker_root_dir: {key: "DockerRootDir", nilable: true, type: String},
      driver: {key: "Driver", nilable: true, type: String},
      driver_status: {key: "DriverStatus", nilable: true, type: Array(Array(String))},
      system_status: {key: "SystemStatus", nilable: true, type: Array(Array(String))},
      plugins: {key: "Plugins", nilable: true, type: Hash(String, JSON::Any)},
      execution_driver: {key: "ExecutionDriver", nilable: true, type: String},
      experimental_build: {key: "ExperimentalBuild", nilable: true, type: Bool},
      http_proxy: {key: "HttpProxy", nilable: true, type: String},
      https_proxy: {key: "HttpsProxy", nilable: true, type: String},
      id: {key: "ID", nilable: true, type: String},
      i_pv4_forwarding: {key: "IPv4Forwarding", nilable: true, type: Bool},
      images: {key: "Images", nilable: true, type: Int32},
      index_server_address: {key: "IndexServerAddress", nilable: true, type: String},
      init_path: {key: "InitPath", nilable: true, type: String},
      init_sha1: {key: "InitSha1", nilable: true, type: String},
      kernel_version: {key: "KernelVersion", nilable: true, type: String},
      labels: {key: "Labels", nilable: true, type: Array(String)},
      mem_total: {key: "MemTotal", nilable: true, type: Int32},
      memory_limit: {key: "MemoryLimit", nilable: true, type: Bool},
      ncpu: {key: "NCPU", nilable: true, type: Int32},
      n_events_listener: {key: "NEventsListener", nilable: true, type: Int32},
      n_fd: {key: "NFd", nilable: true, type: Int32},
      n_goroutines: {key: "NGoroutines", nilable: true, type: Int32},
      name: {key: "Name", nilable: true, type: String},
      no_proxy: {key: "NoProxy", nilable: true, type: String},
      oom_kill_disable: {key: "OomKillDisable", nilable: true, type: Bool},
      os_type: {key: "OSType", nilable: true, type: String},
      oom_score_adj: {key: "OomScoreAdj", nilable: true, type: Int32},
      operating_system: {key: "OperatingSystem", nilable: true, type: String},
      registry_config: {key: "RegistryConfig", nilable: true, type: Hash(String, JSON::Any)},
      swap_limit: {key: "SwapLimit", nilable: true, type: Bool},
      system_time: {key: "SystemTime", nilable: true, type: String},
      server_version: {key: "ServerVersion", nilable: true, type: String},
    })

    def self.new
      from_json Docker.client.get("/info").body
    end
  end
end