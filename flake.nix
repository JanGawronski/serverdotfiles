{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
	    url = "github:nix-community/home-manager/master";
	    inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    musicbot = {
      url = "github:JanGawronski/musicbot";
      inputs.nixpkgs.follows = "nixpkgs";
    }; 
  };
  
  outputs = { nixpkgs, home-manager, agenix, musicbot, ... }: {
    nixosConfigurations.server = nixpkgs.lib.nixosSystem {
      specialArgs = { hostname = "server"; };
      modules = [
        ./configuration/configuration.nix
        agenix.nixosModules.default
        musicbot.nixosModule
        {
          environment.systemPackages = [
            agenix.packages.x86_64-linux.default
          ];
        }
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.user = import ./home/user;
            users.matman = import ./home/matman;
            users.guest = import ./home/guest;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
