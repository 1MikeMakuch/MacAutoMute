//
//  AppDelegate.m
//  AutoMute
//
//  Created by Zac Cohan on 23/8/19.
//  Copyright © 2019 Zac Cohan. All rights reserved.
//

#import "AppDelegate.h"
#import "ScreenStateObserver.h"
#import "ISSoundAdditions.h"

@interface AppDelegate () <ScreenStateObserverDelegate, NSMenuItemValidation>

@property (nonatomic) BOOL enabled;

@property (strong, nonatomic) ScreenStateObserver * screenObserver;
@property (strong, nonatomic) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    self.screenObserver = [ScreenStateObserver new];
    self.screenObserver.delegate = self;
 
    [self setupStatusItem];
    
    self.enabled = true;
}

- (void)setupStatusItem {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    self.statusItem.image = [NSImage imageNamed:@"StatusBarButtonImage"];
    
    self.statusItem.menu = self.statusBarMenu;
    
}

#pragma mark -
#pragma mark Menu Actions & Validation

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    
    if ([menuItem action] == @selector(toggleEnabled:)) {
        
        switch (self.enabled) {
            case YES:
                menuItem.title = @"Disable AutoMute";
                break;
            case NO:
                menuItem.title = @"Enable AutoMute";
                break;
            default:
                break;
        }
        
    }
    
    return YES;
    
}

- (IBAction)toggleEnabled:(id)sender {
    self.enabled = !self.enabled;
}

#pragma mark -
#pragma mark Screen state observer delegate


- (void)screenDidSleep{
    
    if (self.enabled) {
        [NSSound applyMute:YES];
    }
    
}

- (void)screenDidWake {
    
    if (self.enabled) {
         [NSSound applyMute:NO];
    }
    
}

@end
