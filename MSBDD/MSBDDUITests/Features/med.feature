Feature:Medical data Statistics


Scenario Outline:Login page
Given An accounts <ac>
And an asswords <pw>
When Click to login
Then login successful 
And Enter the system

		Examples: 
			|  ac  | pw |
			| john |1234|
			|  may |4567|

Scenario Outline:Insert data page
Given insert medical data:
	|date|temp|syspre|diapre|pulse|spo2|
When Click to Enter
Then Put into the Database
	
Scenario Outline::RUD the data (View data page)
Given RUD the medical data:
	|date|temp|syspre|diapre|pulse|spo2|
When Click to Update
And Click to Delete
Then CRUD the database
