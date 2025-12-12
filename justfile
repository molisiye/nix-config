# just is a command runner, Justfile is very similar to Makefile, but simpler.

# TODO update hostname here!
hostname := `hostname -s`
username := `whoami`
backup_ext := `date +%Y%m%d-%H%M`

# List all the just commands
default:
  @just --list

############################################################################
#
#  Darwin related commands
#
############################################################################

#  TODO Feel free to remove this target if you don't need a proxy to speed up the build process

[group('desktop')]
darwin-set-proxy:
  sudo python3 scripts/darwin_set_proxy.py

[group('desktop')]
darwin:
  nix build .#darwinConfigurations.{{hostname}}.system \
    --extra-experimental-features 'nix-command flakes'

  sudo -E ./result/sw/bin/darwin-rebuild switch --flake .#{{hostname}}

[group('desktop')]
darwin-debug:
  nix build .#darwinConfigurations.{{hostname}}.system --show-trace --verbose \
    --extra-experimental-features 'nix-command flakes'

  sudo -E ./result/sw/bin/darwin-rebuild switch --flake .#{{hostname}} --show-trace --verbose


############################################################################
#
#  nh related commands
#
############################################################################

# Build Home configuration
# build-home username=username hostname=hostname:
#    @echo "Home Manager  Building: {{ username }}@{{ hostname }}"
#    @nh home build . --configuration "{{ username }}@{{ hostname }}"

# Build OS and Home configurations
[group('nh')]
build:
    @just build-home
    @just build-host

# Switch OS and Home configurations
[group('nh')]
switch:
    @just switch-home
    @just switch-host

# Build and Switch Home configuration
[group('nh')]
home:
    @just build-home
    @just switch-home

# Build and Switch Host configuration
[group('nh')]
host:
    @just build-host
    @just switch-host

# Build Home configuration
[group('nh')]
build-home:
    @echo "Home Manager  Building: {{ username }}@{{ hostname }}"
    @nh home build . --configuration "{{ username }}@{{hostname}}"

# Switch Home configuration
[group('nh')]
switch-home:
    @echo "Home Manager  Switching: {{ username }}@{{ hostname }}"
    @nh home switch . --configuration "{{ username }}@{{hostname}}" --backup-extension {{ backup_ext }}

# Build macOS configuration
[group('nh')]
build-host:
      echo "nix-darwin 󰀵 Building: {{ hostname }}"; \
      nh darwin build . --hostname "{{ hostname }}"

# Switch macOS configuration
[group('nh')]
switch-host:
      echo "nix-darwin 󰀵 Switching: {{ hostname }}"; \
      nh darwin switch . --hostname "{{ hostname }}"; \

# Nix Garbage Collection
[group('nh')]
gc:
    @echo "Garbage 󰩹 Collection"
    nh clean all --keep 5

############################################################################
#
#  nix related commands
#
############################################################################

# Update all the flake inputs
[group('nix')]
up:
  nix flake update

# Update specific input
# Usage: just upp nixpkgs
[group('nix')]
upp input:
  nix flake update {{input}}

# List all generations of the system profile
[group('nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
[group('nix')]
repl:
  nix repl -f flake:nixpkgs

# remove all generations older than 7 days
# on darwin, you may need to switch to root user to run this command
[group('nix')]
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

# Garbage collect all unused nix store entries
[group('nix')]
ngc:
  # garbage collect all unused nix store entries(system-wide)
  sudo nix-collect-garbage --delete-older-than 7d
  # garbage collect all unused nix store entries(for the user - home-manager)
  # https://github.com/NixOS/nix/issues/8508
  nix-collect-garbage --delete-older-than 7d

[group('nix')]
fmt:
  # format the nix files in this repo
  alejandra .

# Show all the auto gc roots in the nix store
[group('nix')]
gcroot:
  ls -al /nix/var/nix/gcroots/auto/
