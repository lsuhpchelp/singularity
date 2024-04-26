# When you start the build stage, this Dockerfile by default uses the Ubuntu-based matlab-deps image.
# To check the available matlab-deps images, see: https://hub.docker.com/r/mathworks/matlab-deps
FROM mathworks/matlab-deps:r2023b

# Declare build arguments to use at the current build stage.
ARG MATLAB_RELEASE
ARG MATLAB_PRODUCT_LIST
ARG MATLAB_INSTALL_LOCATION
ARG LICENSE_SERVER

# Install mpm dependencies.
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends --yes \
        wget \
        unzip \
        ca-certificates \
        python3 python3-pip xvfb \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Run mpm to install MATLAB in the target location and delete the mpm installation afterwards.
# If mpm fails to install successfully, then print the logfile in the terminal, otherwise clean up.
# Pass in $HOME variable to install support packages into the user's HOME folder.
RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm \ 
    && chmod +x mpm \
    && ./mpm install \
    --release=r2023b \
    --destination=${MATLAB_INSTALL_LOCATION} \
    --products ${MATLAB_PRODUCT_LIST} \
    || (echo "MPM Installation Failure. See below for more information:" && cat /tmp/mathworks_root.log && false) \
    && rm -rf mpm /tmp/mathworks_root.log ${HOME}/.MathWorks \
    && ln -s ${MATLAB_INSTALL_LOCATION}/bin/matlab /usr/local/bin/matlab

# Note: Uncomment one of the following two ways to configure the license server.

# Option 1. Specify the host and port of the machine that serves the network licenses
# if you want to store the license information in an environment variable. This
# is the preferred option. You can either use a build variable, like this: 
# --build-arg LICENSE_SERVER=27000@MyServerName or you can specify the license server 
# directly using: ENV MLM_LICENSE_FILE=27000@flexlm-server-name
ENV MLM_LICENSE_FILE=$LICENSE_SERVER

# Option 2. Alternatively, you can put a license file into the container.
# Enter the details of the license server in this file and uncomment the following line.
# COPY network.lic ${MATLAB_INSTALL_LOCATION}/licenses/

# The following environment variables allow MathWorks to understand how this MathWorks 
# product (MATLAB Dockerfile) is being used. This information helps us make MATLAB even better. 
# Your content, and information about the content within your files, is not shared with MathWorks. 
# To opt out of this service, delete the environment variables defined in the following line. 
# To learn more, see the Help Make MATLAB Even Better section in the accompanying README: 
# https://github.com/mathworks-ref-arch/matlab-dockerfile#help-make-matlab-even-better
ENV MW_DDUX_FORCE_ENABLE=true MW_CONTEXT_TAGS=MATLAB:DOCKERFILE:V1

ENTRYPOINT ["matlab"]
CMD [""]