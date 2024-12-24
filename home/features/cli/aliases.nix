let
  aliases = {
    "." = "cd ..";
    ".." = "cd ../..";
    "..." = "cd ../../..";
    c = "wl-copy";
    cat = "bat";
    e = "emacsclient -nw";
    ed = "emacsclient";
    flightoff = "sudo rfkill unblock all";
    flighton = "sudo rfkill block all";
    man = "batman";
    mkdir = "mkdir -pv";
    ports = "sudo netstat -tunapl";
    poweroff = "shutdow -h now";
    ps = "procs";
    reboot = "shutdown -r now";
    rm = "rip";
    serve = "python -m http.server";
    sleep = "systemctl suspend -i";
    snr = "sudo systemctl restart NetworkManager";
    tf = "terraform";
    top = "btm";
    watch = "batwatch";
    wget = "wget -c"; # Resume by default
    ls = "eza -a";
    l = "eza -lAh";
    ll = "eza -al";
    pg = "ping 4.2.2.4 -c 5";
  };
in
{
  home.shellAliases = aliases;
}
