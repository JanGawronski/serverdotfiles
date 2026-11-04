{
  networking = {
    interfaces.enp2s0.ipv4.addresses = [ { address = "192.168.1.70"; prefixLength = 24; } ];
    defaultGateway = "192.168.1.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };
}
