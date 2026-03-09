FROM debian:13.2-slim

# Install the build dependencies, including
RUN apt-get update -qq && apt-get install -qq \
    bash rsync \
    build-essential  \
    libsodium-dev \
    nodejs  \
    npm \
    python3 \
    python3-dev  \
    python3-venv

# Copy the application source
WORKDIR /build
COPY auth ./auth
COPY config ./config
COPY core ./core
COPY services ./services
COPY src ./src
COPY templates ./templates
COPY views ./views
COPY install_linux.sh *.py *.json *.toml *.txt *.js .env* ./

# Run the installer script, "n" to skip service installation
RUN mkdir /etc/sudoers.d
RUN yes n | /build/install_linux.sh

# Create the Debian package directory structure
WORKDIR /pkg
RUN mkdir -p /pkg/DEBIAN \
             /pkg/opt/webzfs \
             /pkg/etc/systemd/system \
             /pkg/etc/sudoers.d

# Move the built app, sudoers.d and systemd unit files into the package
RUN cp -r /opt/webzfs/. /pkg/opt/webzfs/ && \
    mv /etc/systemd/system/webzfs.service /pkg/etc/systemd/system/ && \
    mv /etc/sudoers.d/webzfs /pkg/etc/sudoers.d/ && \
	mkdir /pkg/opt/webzfs/.config /pkg/opt/webzfs/.ssh

# Add the DEBIAN hooks and control file
COPY debian/control /pkg/DEBIAN
COPY debian/preinst /pkg/DEBIAN
COPY debian/postinst /pkg/DEBIAN
COPY debian/prerm /pkg/DEBIAN

# Package
RUN dpkg-deb --build /pkg /webzfs_0.65.0_amd64.deb
