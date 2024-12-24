update:
	nix flake update
	nix flake lock

system76-system:
	sudo nixos-rebuild switch --flake .#system76

framework-system:
	sudo nixos-rebuild switch --flake .#framework

homes:
	home-manager switch --flake .#homes

clean-system:
	sudo nix-env --delete-generations old
	sudo nix-store --gc
	sudo nix-channel --update
	sudo nix-env -u --always
	sudo nix-collect-garbage -d
	sudo nix-store --optimise
	home-manager expire-generations "-30 days"
