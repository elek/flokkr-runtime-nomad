#{with var "GELF_ADDRESS"}#
logging {
  type = "gelf"
  config {
    gelf-address = "udp://#{.}#"
  }
}
#{end}#