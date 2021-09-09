# ECSimage
get all docker images in all ECS clusters
[![Create and publish a Docker image](https://github.com/reguengos/ECSimage/actions/workflows/Create-publish-Docker-image.yml/badge.svg?branch=main)](https://github.com/reguengos/ECSimage/actions/workflows/Create-publish-Docker-image.yml)

# Powershell+AWSCLI runner

# container build
'''
docker build . -t pshawscli
'''

# execute image
'''
docker run --rm -it -v C:/Users/jpgsoares/.aws:/root/.aws --env awsprofile=tstdaccess --env 
resultpath=/root/.aws pshawscli
'''

(deveria ser lançado automaticamente com o container, neste momento ainda tenho de logar no container  e executar : /code/Export-task...ps1)

# Env Vars

Pass following env vars:

1-  awsprofile=tstdaccess ( definido no config/credentials)

2- path para o configs ( atraves de map do local path):
-v C:/Users/jpgsoares/.aws:/root/.aws 

3- resultpath=/root/.aws --> resultpath (CSV): ( pode ser o mesmo que o path para o config)
adicionar S3 bucket caso seja necessario.

# EOF
