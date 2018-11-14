# Description:
“C1 Commander” - AutoIt script to automate the modification of Comverse Product Catalog (hereinafter the "PCAT") and Customer Care Client (hereinafter - "CCC") configuration files to connect to one of the pre-defined hardcoded platforms. .

## Installation and run:
### Before use tha App, you should have correctly installed instances of PCAT and CCC programs to default folders.
### “C1 Commander” is distributed by simply copying (Portable). To get started, launch the file “C1 Commander.exe” after retaining it in any convenient directory.
### Select the desired platform from the list in the program "PCAT Launcher" or "CCC Launcher" window.
### Optional:
* Enter your login/password for PCAT or CCC.
* Uncheck Auto Select the latest version for PCAT.
* Change the "SAPI IP" inputBox for desired SAPI. E.x. you can use full domain name: "SAPI1-srt.vimpelcom.ru" or IP: "172.25.186.168"
### Press button “Run PCAT” or "Run CCC". The program'll update config files with selected platform settings and start application.

## Under the hood:
* At startup the program reads the current SDP_IP from the parameter jdbc_url in the jdbc file.properties file and sets the relevant platform at the beginning of the drop-down list "Platform", updating the fields (Platform, SDP_IP, UPM_IP, Timezone).<br>
* On Click “Run PCAT”:
1. Sets the jdbc_url parameter with the value for the selected platform.
2. Changes the setting default_options= “-J-duser DLL.timezone= “ in the file `internal.conf`
3. Saves the Login and Password in the commented out lines at the end of the file `internal.conf`.
4. Changes the "client parameter.connect.URL =" in  `workpoint-client.properties`.
5. At the first start makes a backup for the above files with the extension .bkp in the same folders.
6. Launches "Product Catalog.exe" from the default installation path.
7. Checks that security server url is available and displays warning about propagation if not.

* When the Login field is not empty,  tries to auto login in "Login" window (the occupancy of the Password field for is not checked).
* When the option "Autoselect latest version" is checked, selects the latest version from the list in "Select reseller version" Window.
The state of this jackdaw is not saved between program runs, it is checked by default.
* Changes the window title from the "Product Catalog" to  “PCAT < Platform name> <Timezone>”
* When you try to run a second copy of the PCAT shows a message box and makes active the PCAT window.
</br></br>
*Attention! UPM_IP is only used to change the client parameter.connect.URL = file workpoint-client.properties.
The program does not chage security.server.ip in the security file.properties!*
</br>
* On Click “Run CCC”:
1. Creates a backup file `Comverse.CCBS.CCC.exe.config.bkp` (if it does not exists).
2. Changes SAPIServiceEndPoint setting in `Comverse.CCBS.CCC.exe.config` file using the value from "SAPI IP" inputBox.
3. Saves Login, Password and last selected platform in the commented out lines at the end of the file `Comverse.CCBS.CCC.exe.config`.
4. Launches `Customer Care Client.exe` from the default installation path.
* When the Login field is not empty,  tries to auto login in "Login" window (the occupancy of the Password field for is not checked).
* Changes the window title from the "Customer Care Client" to  “CCC < Platform name>”
* When you try to run a second copy of the CCC, shows a message box and makes active the PCAT window.
</br>

## FAQ:
1. Why after pressing the button “Run PCAT”, the PCAT does not start? Possible causes:
* The process “java.exe” hangs from the previous "PCAT".
* The solution is to kill the process “java.exe” using the Task Manager. (note, with you can kill other running java applications!)
 * Well-known, but poorly investigated bug: any other running program do not allows "PCAT" to start
* A decision is to close all the running programs one by one until the PCAT will not start. (The author noticed that usually the “Skype for Business” and “IE/Helpdesk” closure helped)
2. How to delete previously saved login/password for PCAT or CCC?
* Clean the field Login/Password, and click “Run PCAT” or “Run CCC”
3. How to connect to any the exact SAPI instead of SOAPFARM in CCC?
* Change the "SAPI IP" inputBox for desired SAPI. E.x. you can use full domain name: "SAPI1-srt.vimpelcom.ru" or IP: "172.25.186.168"

### Known issues:
1. The ability to run multiple copies
2. Storing the plaintext password

### Change Log
* 1.2 :
	* Bugfix for autologin feature: special symbols were not sent to PCAT login
* 1.2.1 :
	* Remove using clipboard from autologin feature
* 1.2.2 :
	* Fix timezone for EKT
* 1.2.3 :
	* Fix SDP_IP for RST
	* The `default_options=` string is now updating with platform timezone only (in previous versions the whole string replacement took place with the recommended parameters by vendor).
	* Add the string validation in configs before update
* 2.0 :
	* Add Customer Care Client Launcher
	* Add Help menu
* 2.1 :
	* MSK SDP IP changed