# Lockdown CentOS 7 Hardening Script

This script automates the hardening of CentOS 7 servers.

# This script will:
- Create a new sudo user defined by you
- Update the OS and installs/configures auto-updates
- Move the SSH port to a new port defined by you
- Protects SSH from brute-force with Fail2Ban
- Removes root SSH access, allowing only access by your created user
- Installs and configures anti-virus and root-kit protection (ClamAv and RKHunter)

# Issues/Bugs
Please report any issues or bugs to the Github feed and I'll address them ASAP
