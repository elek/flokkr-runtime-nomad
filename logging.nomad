#{with var "GELF_ADDRESS"}#
logging {
  type = "gelf"
  config {
    gelf-address = "udp://#{.}#"
  }
}
#{end}#
#{with var "JSON_LOGGING"}#
logging {
  type = "json-file"
}
#{end}#
