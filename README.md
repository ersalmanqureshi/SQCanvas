
# SQCanvas

Canvas is a wall for your special photo memories where you can import some special memories from camera/library into canvas and play around it by flipping, cloning, filtering and resizing to fit around its boundary in a square wall.

### Status: work in progress

### Permission

`Canvas` handles permissions for you. It checks and askes for photo and camera usage permissions at first launch. As of iOS 10, we need to explicitly declare usage descriptions in info.plist files

```xml
<key>NSCameraUsageDescription</key>
<string>This app requires access to camera</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires access to photo library</string>
```

## Author
Salman Qureshi, er.salmanqureshi@gmail.com

## License

**SQCanvas** is available under the MIT license. See the LICENSE file for more info.
