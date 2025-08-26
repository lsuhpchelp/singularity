#!/bin/bash
# Clone MWSH management scripts
git clone https://github.com/mathworks-ref-arch/administer-mathworks-service-host.git
#
## admin-controlled service host installation
cd administer-mathworks-service-host/admin-scripts/linux/admin-controlled-installation

./download_msh.sh --destination ./tmp/Downloads/MathWorks/ServiceHost
#./install_msh.sh --source ./tmp/Downloads/MathWorks/ServiceHost --destination /opt/matlab_service_host
./install_msh.sh --source ./tmp/Downloads/MathWorks/ServiceHost --destination /usr/local/packages/license/matlab/matlab_service_host --no-update-environment

