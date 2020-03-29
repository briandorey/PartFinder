# PartFinder
Component inventory website running on asp.net and using a SQL Server Express database.

PartFinder is written in C# and runs on IIS servers on the Windows platform. The storage is using a SQL Server database, either full or express versions.

To create the database tables, add a new database to SQL server called PartFinder and run the setup script in /setup/database.sql to add the new tables and default data. 

Update the connection string MainConn in the web.config with the username and password for your database.

## Setup
When you have setup the database and added the website is IIS, go to the /setup folder in your web browser and create your  create your first user account to sign into Part Finder.

Delete the setup folder once setup is completed.

## Security
The web application can be run on a web server and secured via a username and password using the "users" database table which contains the username as an email address and a hashed password.
 
The system can also can be used for any users on a intranet or local machine without the login requirement by commenting out the following section in the web.config file:
```
<authentication mode="Forms">
      <forms name=".ASPXAUTH" loginUrl="/login.aspx" path="/" timeout="30"  defaultUrl="/default.aspx" />
    </authentication>
    <authorization>
      <deny users ="?" />
      <allow users = "*" />
    </authorization>
```

## Images and File Manager
The admin section contains a file manager which allows you to create directories / folders and add files within the website root in a folder called "/docs". 

This will need the appropriate permissions for the IIS/User account on your server/computer.

### About

More details about this web application can be found on my blog at https://www.briandorey.com/