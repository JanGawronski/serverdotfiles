{pkgs, ...}:
{
  programs.emacs = {
    enable = true;
		package = (pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (epkgs: with epkgs; [
			use-package
			magit
			vterm
			nerd-icons
			nerd-icons-dired
			nerd-icons-ivy-rich
			company
			company-box
			dashboard
			diminish
			counsel
			ivy
			ivy-rich
			toc-org
			org-bullets
			projectile
			lsp-mode
			lsp-ui
			flycheck
			haskell-mode
			lsp-haskell
			lsp-pyright
			rust-mode
			rustic
			cargo
      flycheck-rust
			toml-mode
			git-timemachine
			transient
			vterm-toggle
			rainbow-delimiters
			rainbow-mode
			doom-themes
			which-key
			nix-mode
			nixfmt
      yasnippet
      yasnippet-snippets
      pdf-tools
      company-auctex
      auctex
      multiple-cursors      
    ]); 
	};

  home.file = {
    ".config/emacs" = {
      source = ./emacs;
      recursive = true;
    };
  };
}
