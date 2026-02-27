@echo off
echo Fixing all barter_system imports to skillsocket...

REM Fix all Dart files with barter_system imports
powershell -Command "(Get-Content 'lib\main.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\main.dart'"
powershell -Command "(Get-Content 'lib\main_navigation.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\main_navigation.dart'"
powershell -Command "(Get-Content 'lib\community.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\community.dart'"
powershell -Command "(Get-Content 'lib\studyroom.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\studyroom.dart'"
powershell -Command "(Get-Content 'lib\skillpopup.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\skillpopup.dart'"
powershell -Command "(Get-Content 'lib\profile.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\profile.dart'"
powershell -Command "(Get-Content 'lib\chats.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\chats.dart'"
powershell -Command "(Get-Content 'lib\popup.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\popup.dart'"
powershell -Command "(Get-Content 'lib\signup2.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\signup2.dart'"
powershell -Command "(Get-Content 'lib\chat.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\chat.dart'"
powershell -Command "(Get-Content 'lib\notification.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\notification.dart'"
powershell -Command "(Get-Content 'lib\home.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\home.dart'"
powershell -Command "(Get-Content 'lib\profilepage.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\profilepage.dart'"
powershell -Command "(Get-Content 'lib\splashscreen.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\splashscreen.dart'"
powershell -Command "(Get-Content 'lib\new_chat_screen.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\new_chat_screen.dart'"
powershell -Command "(Get-Content 'lib\reviews.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\reviews.dart'"
powershell -Command "(Get-Content 'lib\signup.dart') -replace 'package:barter_system/', 'package:skillsocket/' | Set-Content 'lib\signup.dart'"

echo Done! All imports updated to skillsocket.