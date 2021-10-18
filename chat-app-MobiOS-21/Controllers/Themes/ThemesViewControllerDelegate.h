//
//  ThemesViewControllerDelegate.h
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 11.10.2021.
//
#import <Foundation/Foundation.h>

#ifndef ThemesViewControllerDelegate_h
#define ThemesViewControllerDelegate_h
@class ThemesViewController;

@protocol ThemesViewControllerDelegate <NSObject>

-(void)themesViewController: (ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;

@end

#endif /* ThemesViewControllerDelegate_h */
