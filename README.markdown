# JUBindings
An iOS alternative to Cocoa Bindings, currently not fully compatible but it does work rudimentary. It follows the Cocoa Bindings syntax, so it should be fairly easy to pick up, although there is no IB support at all.

Checkout the demo to see how much lines of code it saves if you just want to bind your data to some views!

## Example

Simple example to show the basic concept:

	UILabel *label = // ...
	UISlider *slider = // ...
	
	[label bind:@"text" toObject:slider withKeyPath:@"value" options:nil];
	[label bind:@"textColor" toObject:self withKeyPath:@"color" options:nil];
	
	self.color = [UIColor redColor]; // Automagically changes the text color of the label as well.
	
A slightly more interesting example:

    JUUserDefaultsController *defaultsController = [JUUserDefaultsController sharedDefaultsController];
    
    // UISwitch doesn't like it if we provide it with nil, so we set a placeholder value for it.
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], NSNullPlaceholderBindingOption, nil];
	
	// Bind the objects to the defaults controller
    [onSwitch bind:@"on" toObject:defaultsController withKeyPath:@"DemoSwitchState" options:options];
    [textField bind:@"text" toObject:defaultsController withKeyPath:@"DemoTextField" options:nil];
    
    // Bind the default controller to the objects
    [defaultsController bind:@"DemoSwitchState" toObject:onSwitch withKeyPath:@"on" options:nil];
    [defaultsController bind:@"DemoTextField" toObject:textField withKeyPath:@"text" options:nil];

## Using JUBindings
If you want to use JUBindings in your project, you can simply link agains the static library created by the Xcode project, or just copy and paste the code into your project. If you want to use the static library, you **must** also include the following `Other linker flags` in you projects build settings: `-all_load -ObjC`. 

And thats it, you don't need to call any other function or change any of the classes you are already using, everything will work right out of the box!
	
## Currently Implemented
### Controller
**Remark:** None of these controllers is fully implemented, the basic stuff works but there is no Core Data support at the moment!

  * `JUObjectController` (NSObjectController)
  * `JUArrayController` (NSArrayController)
  * `JUUserDefaultsController` (NSUserDefaultsController)
  * `JUTableController` (No AppKit counterpart, used to manage table view like content with sections)
  
### Classes
**Remark:** This is a list of classes that are already exposing some or all of their properties as bindings. 

  * `UIControl`
  * `UIImageView`
  * `UILabel`
  * `UINavigationBar`
  * `UISlider`
  * `UISwitch`
  * `UITableView`
  * `UITextField`
  * `UIView`
  * `UIViewController`
  * `UIWebView`
	
## Whats Missing?
There is a ton of stuff missing, for example there are some controllers that aren't implemented yet, there are no Core Data bindings at the moment (one of the coolest features of Cocoa Bindings) and a lot of classes *should* expose some, or all, of their properties but don't.

I want to implement as much as possible of what is available in Cocoa Bindings, so there is a lot of work ahead. I also want to overwork the `UITableView` handling which I'm not really happy with at the moment. While I don't want to provide the views, I want to provide a better way to bind views with the table views data.

# License
MIT License. Do whatever you want, fork it, break it, branch it! Btw, I also accept push requests ;)