# ONEsite iOS SDK
---
This open source iOS library provides a simple interface for you to integrate ONEsite services into any existing iOS application. More
in depth guides and API documentation can be found [http://developer.onesite.com](http://developer.onesite.com).


### Requirements
---
A development key is required to interact with any of the ONEsite services. You can register for a development key at [http://www.onesite.com/node/ssoSignup)](http://www.onesite.com/node/ssoSignup).


### New Project Setup
---
1. Checkout or untar the onesite-ios-sdk
1. Update the submodule dependencies
	- git submodule update --init --recursive
1. Create a new xcode project
1. Drag the Onesite IOS Sdk project **src/onesite-ios-sdk.xcodeproj** into your project 
1. Under your **Targets** > **Build Phases**:
	1. Under **Target Dependency** section add: 
		- onesite-ios-sdk
	1. Under **Link Binary with Liraries** section add:
		- libonesite_ios_sdk.a
		- CFNetwork.framework
		- CoreGraphics.framework
		- MobileCoreServices.framework
		- SystemConfigurations.framework
		- libz.dylib
1. Under your **Targets** > **Build Settings**:
	1. Update **Header Search Paths** to contain the following recursive entries:
		- ${PATH}/onesite-ios-sdk/src
		- ${PATH}/onesite-ios-sdk/Frameworks/facebook-ios-sdk/src
	1. Under **Other Linker Flags** add the following flags:
		- -ObjC -all_load
1. Configure Onesite specific settings as noted in the **SDK Configuration** section below
1. Configure Facebook as noted in the **Facebook Configuration** section below
1. You should now be able to build your project

### SDK Configuration
---
The sdk uses a plist for global configuration and reads these values in from the client projects version of **onesite.plist**. A copy to place in your project can be found in the config directory. 


### Facebook Configuration
---
1. Add Facebook "fb + app_id" string to your **App-info.plist** by creating a new row **URL Types** > **URL Schemes** > fb + app_id
1. Add Facebook "fb + app_id" string to your **Onesite.plist** in the Facebook section
1. Make your AppDelegate a **UINavigationControllerDelegate** and add the following code to the AppDelegate.m
<pre><code>
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
	if ([url.scheme hasPrefix:@"fb"]) {
		NSLog(@"Facebook URL Request");
		return [[[FacebookWrapper getInstance] facebook] handleOpenURL:url];
    }
	return YES;
}
</code></pre>


### Dependencies
---
The dependencies for the sdk are provided. The dependencies are exported through so they can be used by the application that is currently being developed. The dependencies have been modified from their origonal versions which can be found at:

- **Asi-http-request**
	- http://allseeing-i.com/ASIHTTPRequest/
- **JSONKit**
	- https://github.com/johnezang/JSONKit
- **Facebook-ios-sdk**
	- https://github.com/facebook/facebook-ios-sdk
- **OAuthConsumer**
	- http://code.google.com/p/oauthconsumer/
- **LROAuth2Client**
	- https://github.com/lukeredpath/LROAuth2Client


### License
---
Except as otherwise noted, the ONEsite iOS SDK is licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
