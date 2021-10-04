# tog

A remake of the ÖBB app for iOS.

![Screenshots](resources/screenshots.png)

## Running

You need `CocoaPods` to run this application. Install the dependencies with the following command in the project folder:
```
pod install
```
And open the generated `.xcworkspace` in Xcode, where you can start the app in the simulator.

To start the server, you will also need `Maven`. The following command will generate a database for the server:
```
cd server/railway
mvn spring-boot:run -Dspring-boot.run.profiles=datagen
```
After that, you can start the server without the `datagen` profile.

### Running on a physical device

The iOS app is configured to send requests to `localhost`, which will not work if you're running the app on an iPhone.
You will need to relay traffic through `ngrok`. In `/server/railway`, run:
```
ngrok http 8080
```
`ngrok` will display an address for forwarding. Copy the secure (`https`) one, open `Info.plist` in Xcode and paste
the address in the `SERVER_URL` field. As long as the server and `ngrok` are running, you can run the iOS app on a
physical device.
