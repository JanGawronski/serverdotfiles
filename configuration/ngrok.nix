{config, ...}: {
  services.ngrok = {
    enable = true;
    extraConfigFiles = [ config.age.secrets.ngrok.path ]; 
    endpoints = [
      {
        name = "ssh";
        url = "tcp://";
        upstream.url = 22;
      }
      {
        name = "tcp";
        url = "tcp://";
        upstream.url = 10000;
      }
      {
        name = "https";
        url = "https://superstylishly-interorbital-noelle.ngrok-free.dev";
        upstream.url = 10001;
      }
    ]; 
  };
}
