{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Binary analysis
    binwalk
    hexyl

    # OSINT
    sherlock

    # Network
    nmap
    ncat
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
