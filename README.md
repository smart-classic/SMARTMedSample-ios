SMART Medications Sample
========================

This is a simple sample App to demonstrate basic usage of SMART's [iOS framework][framework]. The interesting parts are:


Registering the App with your SMART container
---------------------------------------------

[server setup instructions go here]

Then, in the SMART framework project, copy the file `Config-default.h` to `Config.h` and adjust the values and your server settings accordingly.


AppDelegate
-----------

The app delegate holds a reference to the `SMServer` instance `smart`, which is the base point for all transactions with our SMART container. Upon App launch, the app delegate sets up this instance with:

	self.smart = [SMServer serverWithDelegate:self];


...
