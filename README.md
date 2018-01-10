# Description:
“PCAT Commander” - AutoIt script to automate the modification of Comverse Product Catalog (hereinafter the "PCAT") configuration files to connect to the platforms in other regions.
You should have the correctly installed to the default folder an instance of PCAT.
“PCAT Commander” is distributed by simply copying (Portable). To get started, launch the file “PCAT Commander.exe” retaining it in any convenient directory. 
## Installation and run:
### Select the desired platform from the list in the program window.
### Optional: 
* Enter a login/password for "PCAT".
* Uncheck Auto Select the latest version.
### Press button “Run the PCAT”

## Features:
* At startup the script reads the current SDP_IP from the parameter jdbc_url in the jdbc file.properties file and sets the relevant platform at the beginning of the drop-down list "Platform", updating the fields (Platform, SDP_IP, UPM_IP, Timezone).<br>
* On Click “Run PCAT”:
1. Sets the jdbc_url parameter with the value for the selected platform.
2. Changes the setting default_options= “-J-duser DLL.timezone= “ in the file `internal.conf`
 3. Saves the Login and Password in the commented out lines at the end of the file `internal.conf`.
1. Password is stored unencrypted, since the data from a database account is uncovered in one of the config files.
4. Changes the "client parameter.connect.URL =" in  `workpoint-client.properties`.
5. At the first start makes a backup for the above files with the extension .bkp in the same folders.
6. Launches "Product Catalog.exe" from the default installation path.
* When the Login field is not empty,  tries to auto login in "Login" window (the occupancy of the Password field for is not checked).
* When the option "Autoselect latest version" is checked, selects the latest version from the list in "Select reseller version" Window.
The state of this jackdaw is not saved between program runs, it is checked by default.
* Changes the window title from the "Product Catalog" to  “PCAT < Platform name> <Timezone>”
* When you try to run a second copy of the PCAT shows a message box and makes active the PCAT window.
</br></br>
*Attention! UPM_IP is only used to change the client parameter.connect.URL = file workpoint-client.properties, 
security.server.ip in the security file.properties is not changing!*

## FAQ:
1. Why after pressing the button “Run PCAT”, the PCAT does not start? Possible causes:
* The process “java.exe” hangs from the previous "PCAT".
* The solution is to kill the process “java.exe” using the Task Manager. (note, with you can kill other running java applications!)
 * Well-known, but poorly investigated bug: any other running program do not allows "PCAT" to start 
* A decision is to close all the running programs one by one until the PCAT will not start. (The author noticed that usually the “Skype for Business” and “IE/Helpdesk” closure helped)
2. How to delete previously saved login/password?
* Clean the field Login/Password, and click “Run PCAT”

### Known issues:
1. The ability to run multiple copies 
2. Storing the plaintext password
