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
    
    copilot-cli.url = "github:scarisey/copilot-cli-flake";
  };
  
  outputs = inputs@{ self, nixpkgs, home-manager, agenix, musicbot, copilot-cli, ... }: { 
    nixosConfigurations = nixpkgs.lib.foldl' (configs: hostname:
      configs // {
        "${hostname}" = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit hostname; };
          modules = [ 
	          ./host/${hostname}/configuration.nix
            agenix.nixosModules.default
            { environment.systemPackages = [
                agenix.packages.x86_64-linux.default
                copilot-cli.packages.x86_64-linux.default
              ]; }
	          musicbot.nixosModule
	          home-manager.nixosModules.home-manager {
		          home-manager = {
			          useGlobalPkgs = true;
			          useUserPackages = true;
			          users.user = import ./host/${hostname}/home.nix;
			          backupFileExtension = "backup";
		          };		
	          }
          ];
        };
      }) {} (builtins.attrNames (builtins.readDir ./host));
  };
}
