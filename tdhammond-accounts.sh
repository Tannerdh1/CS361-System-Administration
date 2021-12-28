#!/bin/sh

#Creates the variables for the name of the file with student information, the course number and the semester it's in,
#the username of the student, their full name, and the user ID which is also used for the group ID.
filename=$1
course="Course"
username="Username"
fullName="FullName"
uID=`cat nextUID.txt` #Reads the number for the next ID to be used from the nextUID.txt file.

#If no textfile is given, print the message and exits the script. $# is the number of arguments passed to the script.
if [ $# -eq 0 ]; then
    echo "No text file given"
    exit 0
fi


while read line; do

    #If the beginning of the current line is Course. Uses cut with a delimiter of : and returns the first field.
    if [ "$(echo "$line" | cut -d ":" -f 1)"  = "Course" ]; then
	#Sets the course variable to the current course number and semester for the following students. Cut -d ":" -f 2 returns everything after Course:.
	course="$(echo "$line" | cut -d ":" -f 2)"
    #The else is for the student information lines.

    else
	
	#Cuts using @ as the delimiter to get the username from the email.
	username="$(echo "$line" | cut -d "@" -f 1)"
	#Cuts using space as a delimiter. Fields 2- will get everything after the space after the email.
	fullName="$(echo "$line" | cut -d " " -f 2-)"
	#Prints the command for creating the group for the user to createAccounts.sh. >> appends the output at the end of the file.
	echo "groupadd -g "$uID" "$username"" >> createAccounts.sh
	#Prints the command for adding the user with their group, home directory, with a comment of their full name and the course, and the /bin/bash shell to createAccounts.sh
	echo "useradd -u "$uID" -g "$uID" /home/student/"$username" -c "$fullName" ("$course") -s /bin/bash" >> createAccounts.sh
	#Increments the uID.
	uID=$((uID+1))

    fi
    
done < "$filename"

#Prints the command to update the UID in nextUID.txt.
echo "$uID > nextUID.txt" >> createAccounts.sh
