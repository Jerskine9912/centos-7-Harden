# lockdown
# This script automates the hardening of CentOS servers, in such a way as to drastically decrease manual sysadmin time and allow non-technical users to implement sound, even if not complete, security of their servers.

# I appreciate any and all feature requests, submit them and I will actively work to incorporate those features.

# Currently the script: 
#   - Creates a new sudo user
#   - Updates OS and installs/configures auto-updates
#   - Moves the SSH port to a new allocation
#   - Protects SSH from brute-force with Fail2Ban
#   - Removes root SSH access
#   - Installs and configures anti-virus and root-kit protection
