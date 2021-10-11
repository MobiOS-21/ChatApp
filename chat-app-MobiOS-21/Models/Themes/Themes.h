//
//  Themes.h
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 11.10.2021.
//
#import <UIKit/UIKit.h>

#ifndef Themes_h
#define Themes_h

@interface Themes : NSObject {
    UIColor* theme1;
    UIColor* theme2;
    UIColor* theme3;
}

- (instancetype) initWithFirstTheme:(UIColor *)theme1 secondTheme:(UIColor *)theme2 thirdTheme:(UIColor *)theme3;
- (void)dealloc;

@property (nonatomic, retain) UIColor *theme1Dark;
@property (nonatomic, retain) UIColor *theme2Light;
@property (nonatomic, retain) UIColor *theme3Pink;

@end
#endif /* Themes_h */
