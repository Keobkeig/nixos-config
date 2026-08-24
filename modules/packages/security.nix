{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Binary analysis
    binwalk
    hexyl

    # OSINT
    sherlock

    # Network
    nmap # also provides ncat; there is no separate `ncat` attribute
    wireshark
    tcpdump

    # Password cracking
    john
    hashcat

    # Web
    gobuster
    ffuf

    # Misc
    radare2
    ghidra
  ];
}
