module Docker
  class Container

    JSON.mapping({
      id: {key: "Id", type: String},
      names: {key: "Names", nilable: true, type: Array(String)},
      image: {key: "Image", nilable: true, type: String},
      image_id: {key: "ImageID", nilable: true, type: String},
      command: {key: "Command", nilable: true, type: String},
      created: {key: "Created", nilable: true, type: Int64},
      status: {key: "Status", nilable: true, type: String},
      ports: {key: "Ports", nilable: true, type: Array(Hash(String, JSON::Any))},
      labels: {key: "Labels", nilable: true, type: Hash(String, String)},
      size_rw: {key: "SizeRw", nilable: true, type: Int32},
      size_root_fs: {key: "SizeRootFs", nilable: true, type: Int32},
      network_settings: {key: "NetworkSettings", nilable: true, type: Hash(String, JSON::Any)},
    })

    def logs(follow = true, stdout = true, stderr = true, since = 0, timestamps = false)
      params = HTTP::Params.build do |qs|
        qs.add "follow", follow.to_s
        qs.add "stdout", stdout.to_s
        qs.add "stderr", stderr.to_s
        qs.add "since", since.to_s
        qs.add "timestamps", timestamps.to_s
      end
      Docker.client.client.get("/containers/#{id}/logs?#{params}") do |response|
        raise "unexpected status code #{response.status_code}" unless response.status_code == 200
        begin
          response.body_io.each_line do |line|
            print line # unless line.strip.empty?
          end
        rescue e
          puts e
          response.body_io.close
        end
      end
    end

    def self.create(image_name)
      Docker.client.post(
        path: "/containers/create",
        headers: HTTP::Headers{"Content-Type" => "application/json"},
        body: "{  \"AttachStdin\" : false,
                  \"AttachStdout\" : true,
                  \"AttachStderr\" : true,
                  \"Tty\" : false,
                  \"Image\" : \"#{image_name}\"
        }")
    end

    def start
      handle_response Docker.client.post("/containers/#{id}/start")
    end

    def stop(wait = 5)
      handle_response Docker.client.post("/containers/#{id}/stop?t=#{wait}")
    end

    def restart(wait = 5)
      handle_response Docker.client.post("/containers/#{id}/restart?t=#{wait}")
    end

    def kill
      handle_response Docker.client.post("/containers/#{id}/kill")
    end

    def remove
      handle_response Docker.client.delete("/containers/#{id}")
    end

    def exec(*commands)
      handle_response (response = Docker.client.post(
        path: "/containers/#{id}/exec",
        headers: HTTP::Headers{"Content-Type" => "application/json"},
        body: "{  \"AttachStdin\" : false,
                  \"AttachStdout\" : true,
                  \"AttachStderr\" : true,
                  \"Tty\" : true,
                  \"Cmd\" : #{commands.to_a.to_s}
                }")
        )

      exec_id = JSON.parse(response.body)["Id"]

      handle_response (result = Docker.client.post(
        "/exec/#{exec_id}/start",
        headers: HTTP::Headers{"Content-Type" => "application/json"},
        body: "{\"Detach\":false, \"Tty\":true}"
      ))
      result.body
    end

    private def handle_response(res)
      case res.status_code
      when 404
        raise Docker::Client::Exception.new("no such container")
      when 500
        raise Docker::Client::Exception.new("server error")
      end
      self
    end

  end
end
