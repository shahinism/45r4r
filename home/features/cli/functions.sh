# shellcheck disable=SC2148

vpn_on () {
    SUGGESTED=$(tailscale exit-node suggest | head -1 | cut -d ':' -f 2 | sed 's/\.$//' | tr -d " ")
    sudo tailscale set --exit-node-allow-lan-access=true --exit-node="$SUGGESTED"
}

vpn_off () {
    sudo tailscale set --exit-node-allow-lan-access=true --exit-node=
}
