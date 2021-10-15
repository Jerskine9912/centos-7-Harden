# Lockdown CentOS 7 Hardening Script

This script automates the hardening of CentOS 7 servers.

# This script will:
- Create a new sudo user defined by you
- Update the OS and installs/configures auto-updates
- Move the SSH port to a new port defined by you
- Protects SSH from brute-force with Fail2Ban
- Removes root SSH access, allowing only access by your created user
- Installs and configures anti-virus and root-kit protection (ClamAv and RKHunter)

# Instructions
1. Use wget to download lockdown.sh to your CentOS 7 machine
2. Allow the running of the script with - chmod -x ~/lockdown.sh
3. Execute the script - sudo bash ~/lockdown.sh
4. This is not a headless installation, you will need to attend and input the desired variables

# Issues/Bugs
Please report any issues or bugs to the Github feed and I'll address them ASAP
