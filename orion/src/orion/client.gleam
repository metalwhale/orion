import gleam/option.{type Option, None, Some}
import gleam/result

import simplifile

pub type ClientCredential {
  ServiceAccountToken(String)
  TlsCertificate(cert: String, key: String)
}

pub type Client {
  Client(
    api_host: String,
    api_port: Int,
    api_cacert: String,
    credential: ClientCredential,
  )
}

pub fn new(
  api_host: String,
  api_port: Int,
  api_cacert: Option(String),
  tls_certificate: Option(#(String, String)),
) -> Result(Client, String) {
  use api_cacert <- result.try(case api_cacert {
    None -> {
      use api_cacert <- result.try({
        // Doc: https://kubernetes.io/docs/tasks/run-application/access-api-from-pod/#directly-accessing-the-rest-api
        let api_cacert_file =
          "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
        simplifile.read(api_cacert_file)
        |> result.map_error(fn(e) {
          e |> simplifile.describe_error <> ": " <> api_cacert_file <> "."
        })
      })
      Ok(api_cacert)
    }
    Some(api_cacert) -> Ok(api_cacert)
  })
  use credential <- result.try(case tls_certificate {
    None -> {
      use token <- result.try({
        // Doc: https://kubernetes.io/docs/tasks/run-application/access-api-from-pod/#directly-accessing-the-rest-api
        let token_file = "/var/run/secrets/kubernetes.io/serviceaccount/token"
        simplifile.read(token_file)
        |> result.map_error(fn(e) {
          e |> simplifile.describe_error <> ": " <> token_file <> "."
        })
      })
      Ok(ServiceAccountToken(token))
    }
    Some(#(cert, key)) -> Ok(TlsCertificate(cert, key))
  })
  Ok(Client(
    api_host: api_host,
    api_port: api_port,
    api_cacert: api_cacert,
    credential: credential,
  ))
}
