# Usar la imagen oficial de PHP con Apache
FROM php:7.4-apache

# Instalar make, wget, zip, unzip y git
RUN apt-get update && apt-get install -y make wget zip unzip git

# Instalar extensiones necesarias de PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Instalar iputils-ping y vim
RUN apt-get install -y iputils-ping && apt-get install -y vim sudo


# Copiar tu aplicación al contenedor
COPY . /var/www/html
WORKDIR /var/www/html



RUN make

# Configurar Apache según las instrucciones del README.md
RUN echo '<VirtualHost *:80>\n\
    ServerName localhost\n\
    DocumentRoot /var/www/html/web\n\
    <Directory /var/www/html>\n\
    Require all granted\n\
    AllowOverride all\n\
    </Directory>\n\
    php_admin_value include_path "/var/www/html/"\n\  
    Include /var/www/html/config/vhost.conf\n\  
    </VirtualHost>' > /etc/apache2/sites-available/000-default.conf

#Habilitar mod_rewrite para Apache
RUN a2enmod rewrite

# Copiar el Makefile al contenedor
#COPY Makefile /var/www/html/Makefile
#Include /var/www/html/web/config-dev/vhost.conf\n\

# Establecer permisos adecuados
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Verificar que los archivos se copiaron correctamente
#RUN ls -la /var/www/html

# Exponer el puerto 80 para el servicio Apache
EXPOSE 80

#RUN echo "Listen 0.0.0.0:80" >> /etc/apache2/ports.conf

# Ejecutar make
#CMD ["make", "install-dev"]

# Iniciar Apache en primer plano
CMD ["apache2-foreground"]