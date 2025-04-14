
# 🛠️ Integración de SonarQube a Docker-Jenkins

## 📘 Introduccion 

SonarQube es una herramienta de análisis estático de código que permite detectar errores, vulnerabilidades, problemas de mantenibilidad y duplicación de código 

Integrar SonarQube con Jenkins permite automatizar este análisis en cada ejecución de una pipeline CI/CD. De esta manera, cada vez que el código se actualiza en el repositorio (por ejemplo, en GitLab), Jenkins se encarga de ejecutar SonarQube, generando informes detallados  del código de forma automática 

Esta guía está centrada en cómo integrar SonarQube dentro del proyecto anterior de docker-jenkins 

------

## 📝 Notas importantes

Para empezar tendrás que reemplazar los dos archivos de esta carpeta a la carpeta principal 

Para integrar el SonarQube, tendremos que tener todo los requisitos hechos ya que esto es una extension del proyecto anterior 

El archivo compose añade un contenedor para SonarQube y el archivo de Jenkinsfile añade varias líneas de código  para integrar el SonarQube a jenkins

## 1. ⚙️ Configuración de SonarQube

### 1.1 Acceso a sonarqube

1. Abre el navegador: `http://localhost:9000`
2. Iniciamos sesión con admin y la contraseña admin

### 1.2 Creacion de proyecto

1. Creamos un proyecto con un nombre y key  `demo`
2. La rama que utilizare `main`
3. Usare la Configuración global para Clean as You Code

### 1.3 Creacion de token 
1.  Ve a "Account" > "My Account" > "Security" 
	- Name: `cualquier nombre`
	- Type: `Global Analysis Token`
	- Expires in: `30days`
	

## 2. ⚙️ Configuración de Jenkins 

### 2.1 Configurar credenciales
1. Ve a "Panel de Control" > "Admin" > "Credentials"
2. Añade la credencial :

   **Para SonarQube:**
   - Tipo: Secret text
   - ID: `dockerhub`
   - Secret: [Token de SonarQube


### 2.2 Configurar SonarQube Scanner

1. Añade el Plugins de SonarQube
	- SonarQube Scanner 
	
2.  Ir a "Manage Jenkins" > "System Configuration" > "Tools"
    
3.  En "SonarQube Scanner" > Add > Name: MySonarQube
    
4.  Marcar “Install automatically” y seleccionar una versión

5. Ir a "Manage Jenkins" > "System Configuration" > "System"

6. En "SonarQube servers" activa "Environment variables"
	- Name : `MySonarQube`
	- URL: `http://localhost:9000/`
	- Server authentication token: `Token de sonarqube`
  
 7. Una vez configurado todo si iniciamos el pipeline debería funcionar todo 
📌 Importante: asegurate que sonar-scanner esté instalado en el contenedor Jenkins o agregado como tool desde la configuración global.

----------

## 3. 🐞 Solución a errores comunes

🛠️ Error: Solo analiza un archivo  
✅ Solución: asegurarse de usar `-Dsonar.sources=.` para escanear todo el proyecto

🛠️ Jenkins no reconoce sonar-scanner  
✅ Solución: Configurar la herramienta “SonarQube Scanner” en “Global Tool Configuration”

🛠️ Error “You must define a 'sonar.projectKey'”  
✅ Solución: Asegurarse de que el flag `-Dsonar.projectKey=demo` esté incluido

----------

## 4. ✅ Ver resultados en SonarQube

-   Abrí [http://localhost:9000](http://localhost:9000/)
    
-   Iniciá sesión (admin/admin)
    
-   Entrá para ver métricas como bugs, duplicaciones, complejidad, etc.
    

