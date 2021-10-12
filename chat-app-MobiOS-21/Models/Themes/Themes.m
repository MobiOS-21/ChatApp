//
//  Themes.m
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 11.10.2021.
//


#import "Themes.h"

@implementation Themes

- (instancetype) initWithFirstTheme:(UIColor *)theme1 secondTheme:(UIColor *)theme2 thirdTheme:(UIColor *)theme3 {
    if (self = [super init]) {
        self.theme1Dark = theme1;
        self.theme2Light = theme2;
        self.theme3Pink = theme3;
    }
    
    return self;
}

- (void)dealloc {
    [theme1 release];
    theme1 = nil;
    
    [theme2 release];
    theme2 = nil;
    
    [theme3 release];
    theme3 = nil;
    
    [theme1Dark release];
    theme1Dark = nil;
    
    [theme2Light release];
    theme2Light = nil;
    
    [theme3Pink release];
    theme3Pink = nil;
    
    [super dealloc];
}

@synthesize theme1Dark;
@synthesize theme2Light;
@synthesize theme3Pink;

- (void)setTheme1Dark:(UIColor *)theme1Dark {
    [theme1 release];
    theme1 = [theme1Dark retain];
}

- (void)setTheme2Light:(UIColor *)theme2Light {
    [theme2 release];
    theme2 = [theme2Light retain];
}

- (void)setTheme3Pink:(UIColor *)theme3Pink {
    [theme3 release];
    theme3 = [theme3Pink retain];
}

//MARK: Getters
- (UIColor *)theme1Dark {
    return theme1;
}

- (UIColor *)theme2Light {
    return theme2;
}

- (UIColor *)theme3Pink {
    return theme3;
}

@end
