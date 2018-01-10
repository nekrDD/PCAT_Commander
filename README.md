Description:
Program “PCAT Commander” is used to automate changes to config files Comverse Product Catalog (PCAT next),
if you want to connect to the platforms in other regions.
For operation of the program requires correctly installed in the default folder program copy Comverse Product Catalog (CBS_PC)
The installation and operation of:
“PCAT Commander” is distributed by simply copying (Portable), to get started, simply launch the file “PCAT Commander.exe” retaining it in any convenient directory. 
In the program window to select the desired platform from the list.
Optional: 
enter the username/password for PCAT-and 
to uncheck Auto Select the latest version
Click “Run PCAT”

Features:
At startup, reads the current SDP_IP of the parameter jdbc_url the jdbc file.properties to run the machine and selects to the beginning of the drop-down list "Platform"the relevant platform, installing in the window spelled out for her. (Platform, SDP_IP, UPM_IP, Timezone).
When you click on the button “Run PCAT”:
1. Records in the file jdbc.the jdbc_url parameter properties for the selected platform
2. Change the setting default_options= “-J-duser DLL.timezone= “ in the file internal.conf
3. Saves the Login and Password in the commented out lines at the end of the file internal.conf.
a. Password is stored unencrypted as the data to access database stored in a nearby file, meaning this.
4. Change the client parameter.connect.URL = file workpoint-client.properties
5. When you first start making a backup of the above files with the extension .bkp in the same folders.
6. Launches "Product Catalog.exe" from the install path by default.
When zapolnena the Login field as soon as the "Login" window tries to run the login (the Password field for the occupancy is not checked).
When the installed Daw "Autoselect latest version", when a window version selects the latest version from the list.
As the jackdaw is not saved between program runs, by default, is installed.
Change the window title from the Product Catalog “PCAT < platform name> <time zone>”
Defines the titles of running Windows programs running already PCAT. When you try to run a second copy of the PCAT-and gives a message and makes active the PCAT.
Attention! UPM_IP is only used to change the client parameter.connect.URL = file workpoint-client.properties, 
security.server.ip in the security file.properties are constantly changing!

FAQ:
Why after pressing the button “Run PCAT” , run the PCAT is not happening?
Possible causes:
Left hanging the process “java.exe” from the previous, incorrectly completed the PCAT.
The solution is to kill the process “java.exe” through the task Manager. (note, with this you can kill other running java applications!)
 Known, but poorly understood bug: PCAT-do not allow to start any other running program
The solution is to close programs that are running alternately until the PCAT will not start. (The author often helped close the “Skype for Business” and “IE/Helpdesk”)
How to delete previously saved login/password
To clean the field Login/Password, and click “Run PCAT”

Known issues:
the ability to run multiple copies 
unencrypted password