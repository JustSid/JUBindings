# JUBindings
An iOS alternative to Cocoa Bindings, currently not fully compatible but it does work rudimentary. It follows the Cocoa Bindings syntax, so it should be fairly easy to pick up, although there is no IB support at all.

Currently this is just a test, so don't expect too much

## Example


	UILabel *label = // ...
	UISlider *slider = // ...
	
	[label bind:@"text" toObject:slider withKeyPath:@"value" options:nil];
	[label bind:@"textColor" toObject:self withKeyPath:@"color" options:nil];
	
## Whats Missing?
Currently, there are no object controller at all. So its not easily possible to build a complete table view with everything from just an array and an array controller.
Also, most classes expose no binding at all, there are a few classes, but even they aren't really supported. Like I said, currently this is just a test and there is a lot of work to do in order to make it a real Cocoa Binding alternative for iOS!

Also, there is no to none documentation for anything. I'm badass, I know!

# License
MIT License. Do whatever you want, fork it, break it, whatever! I also accept push requests!