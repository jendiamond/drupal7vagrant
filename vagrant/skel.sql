CREATE DATABASE drupal CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER 'vagrant'@'localhost' IDENTIFIED BY 'vagrant';
CREATE USER 'vagrant'@'%' IDENTIFIED BY 'vagrant';
GRANT ALL ON drupal.* TO 'vagrant'@'localhost';
GRANT ALL ON drupal.* TO 'vagrant'@'%';
