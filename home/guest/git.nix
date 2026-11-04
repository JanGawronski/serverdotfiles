{
  programs.git = {
		enable = true;
		settings = {
			user = {
				name = "Jan Gawroński";
				email = "jangawronski04@gmail.com";
			};
			init.defaultBranch = "master";
      credential.helper = [
        "!f() { [ \"$1\" = get ] && git credential-store --file /run/agenix/git-credentials get; exit 0; }; f"
        "cache --timeout=3600"
      ];
		};
  };
}
