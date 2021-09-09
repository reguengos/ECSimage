
FROM mcr.microsoft.com/powershell:ubuntu-18.04

# setup powershell & dependencies
# Update the list of products
RUN apt-get update && apt-get install -y \
    libunwind8 \
    powershell \
    unzip


RUN mkdir code
RUN mkdir aws
ADD code ./code
RUN mkdir root/.aws
RUN    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install


# Register Powershell repo
RUN pwsh -command echo "hello world"

