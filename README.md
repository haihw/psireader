# PSI Reader
a mobile application to get data from web and display the data on the application, store the retrieved
data locally so that user can read the data even though there is no internet connection.
## Implemented Requirement  
1. REQ01: Developed a mobile app (iOS) to get the SG PSI value and display it on screen.

2. REQ02: The PSI value can retrieved from the following API & Developer should register to the portal and get the API key to query for the API. https://developers.data.gov.sg/environment/psi

3. REQ03: The API key & other sensitive information should be encrypted securely in the app.

4. REQ04: The mobile app should have a capability to allow user to refresh the latest PSI value from the web

5. REQ05: The mobile app should store the query PSI result locally, so that user will have the last stored PSI value even though there is no internet connection / web service is not available

6. REQ06: The mobile app should display the PSI value according to region: National, south, north, east, central, west

7. REQ07: The mobile app should display the following PSI value.

- psi_twenty_four_hourly

- psi_three_hourly

8. REQ08: Below are the basic mockup of the UI, feel free to use it as a reference or improve it.

## Implemented Bonus Requirement
1. BONUS01: If there is no network connection, after timeout, the mobile app should prompt and notify user and ask for user retry.

2. BONUS02: While the app is sending the query to pull the data, the app should able to prompt a progress dialog with cancel button to allow user cancel the operation.

3. BONUS03: Implement activity log feature to keep track of the previous query result on PSI app

4. BONUS07: Create a script to App project (.ipa) and copied it into a folder (e.g. project_root_folder\Deliverables).
## Developement time
1. Main Requirement: 3h
2. Bonus Requirement: 4h

## Test plan:
1. TC01: test the live data

- Step 1: Lunch apps with internet connection
- Expected result: the data is loaded automatically and displayed fully all region with 2 value 24h PSI and 3h PSI
- Step 2: Tap refresh button
- Expected result: The loading indicator is showed and the data is loaded and displayed fully all region with 2 value 24h PSI and 3h PSI. The loading indicator should be able to tap to cancel action
- Step 3: Turn on airplan mode
- Expected result: The pop up alert with 2 option "cancel" "retry" is prompted. Click on "retry", should be able to load data again. 

2. TC02: test offline activity log

- preconditions: existing apps with few times refreshed. 
- Step 1: Turn on airplan mode and Lunch apps
- Expected result: should be able to see the last result
- Step 2: click on History button
- Expected result: should be able to see the list of time stamps
- Step 3: click on any time stamp
- Expected result: should be able to see the PSI detail
- Step 4: click on "Clear History" button
- Expected result: should be able to clear the history data

3. TC03: test build script
- Step 1: run command from project root folder: sh BuildScript.sh
- expected result: the ipa file should be exported to project_root_folder\Deliverables