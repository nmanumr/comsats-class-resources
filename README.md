# COMSATS Class Resources

This app provides a plateform to share class learning resources specially for COMSATS Students. Includes following features:

* Share class resources
* Share course timetable, events and reminders like assignments deadlines etc
* Get notified about upcomming deadline or events

## Running locally
Assuming flutter is setuped locally

```
# Running in debugging mode
flutter run

# Running in release mode
flutter run --release

# Cloud functions
cd ./cloud_functions/functions
npm install

# Running shell for functions testing
npm run shell

# Invoking a function in shell
func_name(data)

# Generate debug signing key
keytool -genkey -v -keystore ~/.android/debug.keystore -alias debug -keyalg RSA -keysize 2048 -validity 10000


# Generate signing key finger print
keytool -list -v -keystore path/key.jks -alias key
```

## TODO

- [ ] Improve README
- [ ] Implement custom timetable widget
- [ ] Improve user profile related tasks
- [ ] Implement in-app theme switcher
- [ ] Implement user roles and privileges
- [ ] Implement tasks and push notifications
- [ ] Add license, privacy policies, about and more apps pages