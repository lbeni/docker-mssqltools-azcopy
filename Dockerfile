FROM microsoft/dotnet:latest

MAINTAINER Leandro Beni <leandrobbeni@gmail.com>

# Accept licence for Silent installation
ENV ACCEPT_EULA=Y

# Install mssql-tools and dependencies
RUN apt-get update && apt-get -y install gnupg apt-transport-https locales && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && apt-get install -y msodbcsql17 mssql-tools unixodbc-dev && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

# Install azcopy
RUN apt-get update && apt-get install -y --no-install-recommends rsync && \
    mkdir /tmp/azcopy && \
    curl -L https://aka.ms/downloadazcopyprlinux | tar zxv -C /tmp/azcopy && \
    /tmp/azcopy/install.sh && \
    rm -rf /tmp/azcopy

# Add sqlcmd and bcp on path
ENV PATH="/opt/mssql-tools/bin:${PATH}"
