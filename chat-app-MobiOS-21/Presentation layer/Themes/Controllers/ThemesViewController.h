//
//  ThemesViewController.h
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 11.10.2021.
//
#import <UIKit/UIKit.h>
#import "Themes.h"
#import "ThemesViewControllerDelegate.h"

#ifndef ThemesViewController_h
#define ThemesViewController_h
@interface ThemesViewController : UIViewController {
    id<ThemesViewControllerDelegate> _delegate;
    Themes *_model;
}

@property(retain, nonatomic) Themes *model;
@property(assign, nonatomic) id<ThemesViewControllerDelegate> delegate;

@end
#endif /* ThemesViewController_h */
