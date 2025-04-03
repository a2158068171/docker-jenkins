#!/bin/bash

# Configuración
DOCKER_USER="TU_NOMBRE_USUARIO_DOCKERHUB"  
DOCKER_PASS="CONTRASEÑA/TOKEN_ACCESO_DE_DOCKERHUB" 
IMAGE_PREFIX="$DOCKER_USER/"        


echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

docker commit gitlab ${IMAGE_PREFIX}gitlab-custom:latest && \
docker push ${IMAGE_PREFIX}gitlab-custom:latest

docker commit jenkins ${IMAGE_PREFIX}jenkins-custom:latest && \
docker push ${IMAGE_PREFIX}jenkins-custom:latest