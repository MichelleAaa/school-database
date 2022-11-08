# School Database with SQL

This project features an Entity Relationship diagram of a school database made with drawio and the corresponding school database SQL code. 


## Project Screen Shots


<!-- PENDING

![PENDING](img/IMG.png "PENDING")

PENDING -->



## Launch Instructions

Clone or download this repository to your local machine. 

Please verify that docker desktop has been installed on your machine. If it hasn't, please visit [here for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows/) or [here for Mac](https://docs.docker.com/docker-for-mac/install/)  for installation instructions.

Open the file folder in VS code.

Open Docker Desktop.

In VS code, click View -> Terminal.

In the terminal, type in the following comamnd to start the containers from the docer-compose.yaml file:
docker compose up -d

Run the following to launch the database:
cat school_database.sql | docker exec -i pg_container psql

You will see notifications in the terminal of the additions:

<!-- PHOTO PENDING -->
![Terminal Screenshot](img/img.img "UPDATE SOON.")


Note that at the end, the SQL queries from the last section will also run:

<!-- PHOTO PENDING -->
![SQL Queries](img/img.img "SQL Queries.")



Open the pgAdmin panel in your browser:
http://localhost:5433

Click on "Add New Server"

Add a Name in the General tab.
Add 'pg' as the Host Name/Address on the connection Tab.
Click Save.

On the left side, double click on the Servers button. follow the path:
Servers -> School -> Databases -> Schemas -> Tables 
This will bring you to the list of all 8 of the tables created with this database.


## Reflection

I created this database after finishing NuCamp's Back End, SQL, and DevOps Developer with Python bootcamp. The goal was to practice creating an Entity Relationship Diagram as well as converting the diagram into sql code. Additionally, some sample SELECT statements were added to cement some of the foundational concepts of how to query the database.


## References

- "Entity-Relationship Diagram: School Class Generation" - https://www.youtube.com/watch?v=r4t3-tvL8B0 (Inspiration for the ER diagram.)
- NuCamp's Back End, SQL, and DevOps Developer with Python Bootcamp (The docker-compose.yml and .env files as well as the database configuration setup at the top of the school_database.sql file were adapted from the NuCamp curriculum as a simple way to run the database code.)