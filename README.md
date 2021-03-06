mnubo iOS SDK
============

iOS SDK allowing iOS apps to quickly implement the mnubo REST API.

## How To Get Started

1. Install [CocoaPods](http://cocoapods.org/) with `gem install cocoapods`.
2. Create a file in your XCode project called `Podfile` and add the following line:

    ```ruby
    pod 'mnuboSDK'
    ```

3. Run `pod install` in your xcode project directory. CocoaPods should download and
install the mnubo iOS SDK, and create a new Xcode workspace. Open up this workspace in Xcode.


## Architecture

### mnubo

The primary class of the SDK has to be initialize with your mnubo account informations (name, namespace, consumer keys, consumer secrets). mnubo REST API calls are represented by a method of that class.

* `SDK Management`
  - `sharedInstanceWithClientId:clientSecret:hostname:`
  - `sharedInstance`
  - `enableLogging`/`disableLogging`
  - `isLoggingEnabled`
* `User Management`
  - `createUser:updateIfAlreadyExist:completion:`
  - `updateUser:completion:`
  - `getUserWithUsername:completion:`
  - `deleteUserWithUsername:completion:`
  - `getObjectsOfUsername:completion:`
  - `changePasswordForUsername:oldPassword:newPassword:completion:`
  - `resetPasswordForUsername:`
  - `confirmResetPasswordForUsername:newPassword:token:`
  - `confirmEmailForUsername:password:token:completion:`
* `Object Management`
  - `createObject:updateIfAlreadyExist:completion:`
  - `updateObject:completion:`
  - `getObjectWithObjectId:completion:`
  - `getObjectWithDeviceId:completion:`
  - `deleteObjectWithObjectId:completion:`
  - `deleteObjectWithDeviceId:completion:`
* `Send Sensor Data`
  - `sendSample:toPublicSensorName:withObjectId:completion:`
  - `sendSample:toPublicSensorName:withDeviceId:completion:`
  - `sendSample:forObjectId:completion:`
  - `sendSample:forDeviceId:completion:`
* `Fetch Sensor Data`
  - `fetchLastSampleOfObjectId:sensorName:completion:`
  - `fetchLastSampleOfDeviceId:sensorName:completion:`
  - `fetchSensorDatasOfObjectId:sensorDefinition:fromStartDate:toEndDate:completion:`
  - `fetchSensorDatasOfDeviceId:sensorDefinition:fromStartDate:toEndDate:completion:`
  - `fetchSensorDataCountOfObjectId:sensorDefinition:fromStartDate:toEndDate:completion:`
  - `fetchSensorDataCountOfDeviceId:sensorDefinition:fromStartDate:toEndDate:completion:`
* `Oauth 2`
  - `logInWithUsername:password:completion:logOutErrorCompletion:`
  - `logOut`
  - `isUserConnected`

## Usage

### Initialize mnubo

We recommend to use the shared instance of the mnubo SDK in your application and should initialize the SDK as follows in your app delegate:

```objc
#import <mnuboSDK/mnubo.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  [mnubo sharedInstanceWithClientId:@"CLIENT_ID" clientSecret:@"CLIENT_SECRET" hostname:@"BASE_URL"];

  return YES
}
```

### Create/Register an user

To create an new user, you must create an MBOUser object (include in the SDK) and set its attributes according to the data provided by the end user. To save it in the mnubo platform, use the createUser:updateIfAlreadyExist:completion: method with your new user as parameter. See the example below.

```objc

MBOUser *newUser = [[MBOUser alloc] init];
newUser.username = @"USERNAME";
newUser.password = @"USER_PASSWORD"; // optional
newUser.confirmedPassword = @"USER_PASSWORD"; // optional
newUser.firstName = @"USER_FIRST_NAME"; // optional
newUser.lastName = @"USER_LAST_NAME"; // optional
newUser.registrationDate = [NSDate date]; // optional

[[mnubo sharedInstance] createUser:newUser updateIfAlreadyExist:YES completion:^(MBOError *error) {
}];

```

###User Confirmation
After the user is created in the mnubo platforme, an email is automatically sent to the user ton confirm the user registration. To do so, simply call the SDK method with the token received by the user in his email.

```objc
// Confirm the email of the user
[[mnubo sharedInstance] confirmEmailForUsername:@"USERNAME" password:@"USER_PASSWORD" token:@"EMAILED_TOKEN" completion:^(MBOError *error) {
  if (!error) {
    // Everything went fine
  }
}];
```

### Log In an user

Once a user is present in the mnubo platform, an authentication can be executed to fetch the user's access tokens. This login method requires the username and the password of the user to authenticate.

```objc

[[mnubo sharedInstance] logInWithUsername:@"USERNAME" password:@"PASSWORD" completion:^(MBOError *error)
{
  if (!error) {
    // The user is connected and can now use the app
  } else {
    // An error occured while login the user
  }
}
oauthErrorCompletion:^(MBOError *)error
{
  // Show login view
}];

```

### Check if an user is connected

At anytime you can validate if a user is connected. Simply retrieve a boolean with the help of the isUserConnected method.

```objc

// YES if the user is connected and NO if the user is not currently connected
BOOL isUserConnected = [[mnubo sharedInstance] isUserConnected];
```

### Log Out an user

When the user needs to be logged out, the logOut method will clear all of the user's access tokens. After that operation, the isUserConnected method will return NO (false). Access to restricted section of your app should be made unavailable.

```objc
// Log the user out and clear all the tokens
[[mnubo sharedInstance] logOut];

```

### Reset Password

When a user request a password reset, 2 steps are required to complet the process. The first one (resetPasswordForUsername: method) will send an email to the user containing an unique token. he user needs to provide this token to the app in order to complet the second step (confirmResetPasswordForUsername:newPassword:token: method) as well as a new password. See example below.

#### 1st Step
```objc
// Request an email with a token to reset the password
[[mnubo sharedInstance] resetPasswordForUsername:@"USERNAME" completion:^(MBOError *error) {
  if (!error) {
    // Everything went fine
  }
}];
```
#### 2nd Step
Once the user recieve the token by email
```objc
// Enter the token recieved by email
[[mnubo sharedInstance] confirmResetPasswordForUsername:@"USERNAME" newPassword:@"NEW_PASSWORD" token:@"TOKEN_FROM_EMAIL" completion:^(MBOError *error) {
  if (!error) {
    // Everything went fine
  }
}];
```

### Create an object

Once an user is correctly logged in, objects can be created and sent to the mnubo platform. To to so, a MBOObject is created and the data can be added accordingly with the object type. To save the object in the mnubo platform, use the createObject: updateIfAlreadyExist:completion: method while providing the new object.

```objc

MBOObject *newObject = [[MBOObject alloc] init];
newObject.deviceId = @"DEVICE_ID";
newObject.objectModelName = @"OBJECT_MODEL_NAME";
newObject.owner = @"USERNAME";
newObject.registrationDate = [NSDate date]; // optional

[[mnubo sharedInstance] createObject:newObject updateIfAlreadyExist:YES completion:^(MBOObject *newlyCreatedObject, MBOError *error) {
}];

```



### Post Sensor Data

At anytime, you can send samples of a specific object's sensor.

```objc

MBOSample *sample = [[MBOSample alloc] initWithDictionary:@{@"name": @"generic_event"}];
[sample addSensorWithName:@"value" andDictionary:@{@"event_type": @"command2"}];

// Send the sample to the mnubo platform ny eother specifying the device_id or the object_id
[[mnubo sharedInstance] sendSample:sample withObjectId:@"OBJECT_ID" orDeviceId:@"DEVICE_ID" completion:^(MBOError *error) {
}

```

All the "sendSensorData" methods have an internal retry mechanism, if the send failed with a retryable error (also if there is no internet connection), the errorCode of the MBOError of the completion block will be set to MBOErrorCodeWillBeRetryLaterAutomatically and the job will be retry after the number of seconds configured in sensorDataRetryInterval (default to 30 seconds). The retry queue is persisted on disk, so the jobs will be retried also after a restart of the application. If you want to disable that feature you can set the property disableSensorDataInternalRetry to NO on your mnubo object.

### Post Samples to Public Sensors
It is now possible to send samples to sensors marked as public. Simply use the method instead of the previous one. Note that this functionality only support to send one sample at a time.

```objc

[[mnubo sharedInstance] sendToPublicSensorASample:(MBOSample *)sample withName:@"SENSOR_NAME" withObjectId:@"OBJECT_ID" orDeviceId:@"DEVICE_ID" completion:(MBOError *error) {
  //Sample sent
}


```

### Fetch Sensor Data

```objc

MBOSensorDefinition *sensorDefinition = [newlyCreatedObject getSensorDefinitionOfSensorName:@"SENSOR_NAME"];

[[mnubo sharedInstance] fetchLastSensorDataOfObjectId:newlyCreatedObject.objectId sensorDefinition:sensorDefinition completion:^(MBOSensorData *sensorData, MBOError *error) {
}];

```

### Logging
It is possible to enable or disable the logging of the SDK at any time
```objc
// Enable
[mnubo enableLogging];

// Disable
[mnubo disableLogging];

// Check if the logging is enabled
BOOL isEnabled = [mnubo isLoggingEnabled];
```
