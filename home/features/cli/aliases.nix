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
    sleep = "systemctl suspend";
    snr = "sudo systemctl restart NetworkManager";
    tf = "terraform";
    top = "btm";
    watch = "batwatch";
    wget = "wget -c"; # Resume by default
    ls = "eza";
  };
in { home.shellAliases = aliases; }
