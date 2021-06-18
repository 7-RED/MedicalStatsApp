Feature:Medical data Statistics

Scenario Outline:ContentView page
	Given An email <email>
	And an password <pw>
	When Click to the LOGIN
	Then login successful
	And Enter the ListView

Scenario Outline:ListView page
	Given Messages in to the TextField
	When Click to the Add
	Then Input message to Firebase FireStore database
	When Click to the Edit
	Then Can delete database
	When Click to the list
	Then Can update any database
	
	When click to the Logout
	Then Logout this system
	And Cannot CRUD the database
