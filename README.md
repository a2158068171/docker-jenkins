# Jenkins + GitLab + Docker Hub 

## ℹ️ Introducción 
 Este es un repositorio que proporciona una configuración para levantar un entorno de integración continua (CI/CD) utilizando Jenkins y GitLab dentro de los contenedores de Docker Hub, facilita la automatización de tareas como compilación, prueba, creación de imágenes Docker y despliegue 

Esta hecho para Windows 10/11 con WSL2 y Docker, pero también se podría trasladar este proyecto a GNU/LINUX cambiando para algunas configuraciones

## ❗SonarQube

Si quieres integrar directamenter SonarQube al proyecto lea [SonarQube](https://github.com/a2158068171/docker-jenkins/tree/main/sonarqube)

Es un compose y jenkinsfile para tener preparado el sonarqube para integrarlo despues

## 🧱 Componentes principales

- `docker-compose.yml` : Es un archivo para orquestar los dos contenedores (Jenkins y GitLab) de forma automática sin necesidad de configurarlos, mediante un solo comando 

- `Jenkinsfile`:Define como será la pipeline de Jenkins, dividendo en tres  etapas: descarga del código de GitLab, comprueba las credenciales y por ultimo crea una imagenes personalizadas y la sube a DockerHub 

- `build_and_push.sh` : Automatiza el inicio de sesión a Docker Hub mediante variables y luego crea imágenes personalizadas de (Jenkins y GitLab) y las publica en el repositorio 

## 🔍 Requisitos Previos
- Windows 10/11 con WSL2 activado
- Docker Desktop instalado
- Cuenta en Docker Hub

---

## 1️⃣ CONFIGURACIÓN INICIAL

### 1.1 Instala Docker y Docker Compose
Descarga [**Docker Desktop**](https://www.docker.com/products/docker-desktop/)

Una vez descargado e instalado el Docker Desktop comprobamos

```powershell
docker --version
docker-compose --version
```
### 1.2 Generar Token de Acceso

1. Ve a "Account Settings" > "Personal access tokens"
2. Selecciona Generate new token
3. Access permissions: `Read & Write`


### 1.3 Crear estructura de archivos
```bash
git clone https://github.com/a2158068171/docker-jenkins.git
cd docker-jenkins
```

### 1.4 Iniciar contenedores

Iniciamos el docker-compose.yml que nos hemos traído del GitHub
```bash
docker-compose up -d
```

---

## 2️⃣ CONFIGURACIÓN DE GITLAB

### 2.1 Obtener contraseña Root Gitlab
```bash
docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
```

### 2.2 Acceso a GitLab
1. Abre el navegador: `http://localhost:8081`
2. Iniciamos sesión con root y la contraseña anterior
3. Crea un nuevo repositorio: `docker-jenkins`
4. Añade los archivo Jenkinsfile y build_and_push.sh  al repositorio
```
git init
git remote add origin http://localhost:8081/root/docker-jenkins.git
git add .
git commit -m "descripcion"
git push -u origin main
```


### 2.3 Crear Token de Acceso
1. Ve a "User Settings" > "Access Tokens"
2. Selecciona Add new token
3. Nombre: `docker jenkins`
4. Selecciona scopes: `api`, `read_repository`, `write_repository`

 ### 📌 Nota
  Configura el archivo build_and_push.sh con tus credenciales de DockerHub
  Guia para [GitLab](https://docs.gitlab.com/tutorials/learn_git/) 
 
---

## 3️⃣ CONFIGURACIÓN DE JENKINS

### 3.1 Obtener contraseña Admin
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### 3.2 Acceso a  Jenkins
1. Abre el navegador: `http://localhost:8080`
2. Iniciamos sesión con admin y la contraseña anterior 
3. Instala Plugins por defecto
4. Añade los siguientes Plugins
	- Plugin de integración con GitLab
    - Plugin de análisis de dependencias OWASP

### 3.3 Configurar credenciales
1. Ve a "Panel de Control" > "Admin" > "Credentials"
2. Añade dos credenciales:

   **Para GitLab:**
   - Tipo: Username with password
   - ID: `gitlab-token`
   - Username: `root`
   - Password: [Token de GitLab]

   **Para Docker Hub:**
   - Tipo: Secret text
   - ID: `dockerhub`
   - Secret: [Token de Docker Hub]

---

## 4️⃣ Instalación de Docker CE CLI en Jenkins
 

### 4.1 Acceder al contenedor Jenkins como root

```bash
docker exec -u root -it jenkins /bin/bash
```

### 4.2 Instalar dependencias necesarias

```bash
apt-get update 
apt-get install -y ca-certificates curl gnupg lsb-release
```
### 4.3  Configurar repositorio de Docker
```
mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] [https://download.docker.com/linux/debian](https://download.docker.com/linux/debian "https://download.docker.com/linux/debian") $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
```

### 4.4 Instalar Docker CLI
```
apt-get update && apt-get install -y docker-ce-cli

docker --version
```
---

## 5️⃣ EJECUTAR EL PIPELINE
### 5.1 Crear pipeline Jenkins
   - Crea un Nuevo Tarea
   - Selecciona "Pipeline"
   - Entra en la configuración y cambiamos "Pipeline script" > "Pipeline script from SCM"
   - Configura:
     - SCM: Git
     - Repository URL: `http://gitlab/root/docker-jenkins.git`
     - Credentials: `gitlab-token`
    - Branches to build
	    - cambia el "*/master" > " */main"
	- Guarda la configuración 
### 5.2 Iniciar build

Una vez configurado todo solo tendría que volver al Panel de Control de Jenkins y ejecutar el pipeline 

---

## 🔧 SOLUCIÓN DE PROBLEMAS


### Error: Permisos denegados
```bash
docker exec -u root -it jenkins chmod 666 /var/run/docker.sock
```

### Error: Push denegado
- Verifica que el token de Docker Hub tenga permisos **Read & Write**
- Asegúrate que los nombres de imagen incluyan tu usuario: `usuario/nombre-imagen`
---

## ✅ VERIFICACIÓN FINAL
- Imágenes en Docker Hub: `https://hub.docker.com/r/tu_usuario/`
- Pipeline exitoso mostrará: `Finished: SUCCESS`


### 📌 Notas Importantes:
1. Los tokens son sensibles, nunca los compartas
2. Se recomienda borrar token de Docker Hub después del su uso 
3. Si falla el pipeline, revisa los logs en "Console Output"


### 🔗Enlaces de interes
[Usando Jenkins y Docker - Adictos al trabajo](https://www.jenkins.io/doc/book/installing/docker/)

[jenkins/jenkins - Docker Image | Docker Hub](https://hub.docker.com/r/jenkins/jenkins)

[Docker](https://www.jenkins.io/doc/book/installing/docker/)
