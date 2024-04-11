update:
	nix flake update
	nix flake lock

system76-system:
	sudo nixos-rebuild switch --flake .#system76

system76-home:
	home-manager switch --flake .#shahin@system76

system76: system76-system system76-home

framework-system:
	sudo nixos-rebuild switch --flake .#framework

framework-home:
	home-manager switch --flake .#shahin@framework

framework: framework-system framework-home

clean-system:
	sudo nix-env --delete-generations old
	sudo nix-store --gc
	sudo nix-channel --update
	sudo nix-env -u --always
	sudo nix-collect-garbage -d
