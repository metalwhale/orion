import gleam/int
import gleam/io
import gleam/option.{None, Some}

import envoy
import simplifile

import orion/client

pub fn main() {
  let assert Ok(api_host) = envoy.get("KUBERNETES_SERVICE_HOST")
  let assert Ok(api_port) = envoy.get("KUBERNETES_SERVICE_PORT_HTTPS")
  let assert Ok(api_port) = int.parse(api_port)
  let assert Ok(cert_file) = envoy.get("KUBERNETES_CLIENT_CERT")
  let assert Ok(cert) = simplifile.read(cert_file)
  let assert Ok(key_file) = envoy.get("KUBERNETES_CLIENT_KEY")
  let assert Ok(key) = simplifile.read(key_file)
  let client = client.new(api_host, api_port, None, Some(#(cert, key)))
  io.debug(client)
}
