##Docker container for MongoDB data wrapper launch inside Postgresql
As explained in this blog post this docker image allows you to lauch a postgres engine with mongodb data wrapper ready to be configured. This file is based on official Postgresql container but with ubuntu instead of debian (i did not manage to make the MongoDB FDW works on a debian).     
To use it :
#####Build and launch the container    
**sudo docker build  -t mongodbfw .**    
**docker run --name a-mongodbfw -d <hash given by the build>**   
#####And then connect
**docker run -it --link a-mongodbfw:postgres --rm postgres sh -c 'exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'**    
At this point you will just have to create the extension and the foreign table before starting querying data. Don't forget that your MongoDB server is not launch in your container. You may use the docker interface of your laptop (172.17.42.1) in the server description step.*
##LICENSE
This DockerFile is released under the MIT Licence. It is open source and free of charge.