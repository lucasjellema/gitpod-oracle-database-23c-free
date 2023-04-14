# gitpod-oracle-database-23c-free
Run Gitpod workspace with Oracle Database 23c Free

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/lucasjellema/gitpod-oracle-database-23c-free)


Oracle Database 23c Free is running in a container called *23cfree*.
You can access the database at port 1521 on localhost - using user SYS (as SYSDBA) and password TheSuperSecret1509! or user *dev* with password *DEV_PW*

From a bash terminal, you can connect into the database using SQL*Plus with this command:

```
docker exec -it 23cfree sqlplus sys/TheSuperSecret1509! as sysdba
```

The database is started using the Docker Container image prepared by Gerald Venzl. See [Container Image Details](https://container-registry.oracle.com/ords/f?p=113:4:116729705491998:::4:P4_REPOSITORY,AI_REPOSITORY,AI_REPOSITORY_NAME,P4_REPOSITORY_NAME,P4_EULA_ID,P4_BUSINESS_AREA_ID:1863,1863,Oracle%20Database%20Free,Oracle%20Database%20Free,1,0&cs=3a8c38qNZ-qkPvm0nwLnAj8Beg7b1gzprb9XP2yQtQSyeZc-9cHiFA5wGa_B0KICeppaUQkKeYPGmbLqNb74OFg). 

You can use the VS Code Oracle Developer Tools extension for VS Code - which is preconfigured with a database connection for the SYS account.

SQLcl command line tool (see [SQLcl introduction](https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/) for details) has also been installed and can be accessed using:

```
sql sys/"TheSuperSecret1509!"@localhost:1521/23cfree as sysdba 
```  

A database user has been setup with username DEV and password DEV_PW in PDB `FREEPDB1`. A connection for this user is created in VS Code Oracle Developer Tools. Connect through SQLcl can be done using:

```
sql DEV/DEV_PW@localhost:1521/FREEPDB1 
```  

## Resources

Introducing Oracle Database 23c Free – Developer Release - Blog by Gerald Venzl Senior Director - 4th April 2023 - https://blogs.oracle.com/database/post/oracle-database-23c-free

Oracle Database Free Release Quick Start - https://www.oracle.com/database/free/get-started/

Oracle Container Registry –Database Repositories  – [Oracle Database Free](https://container-registry.oracle.com/ords/f?p=113:4:116729705491998:::4:P4_REPOSITORY,AI_REPOSITORY,AI_REPOSITORY_NAME,P4_REPOSITORY_NAME,P4_EULA_ID,P4_BUSINESS_AREA_ID:1863,1863,Oracle%20Database%20Free,Oracle%20Database%20Free,1,0&cs=3a8c38qNZ-qkPvm0nwLnAj8Beg7b1gzprb9XP2yQtQSyeZc-9cHiFA5wGa_B0KICeppaUQkKeYPGmbLqNb74OFg) – this page provides details on the container image for the database and how to connect to it.

