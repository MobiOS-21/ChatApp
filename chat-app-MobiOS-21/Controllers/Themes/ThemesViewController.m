//
//  ThemesViewController.m
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 11.10.2021.
//

#import <UIKit/UIKit.h>
#import "ThemesViewController.h"

@interface ThemesViewController ()

@end

@implementation ThemesViewController

//MARK: - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *firstColor = [UIColor grayColor];
    UIColor *secondColor = [UIColor whiteColor];
    UIColor *thirdColor = [UIColor systemPinkColor];
    
    _model = [[Themes alloc] initWithFirstTheme:firstColor secondTheme:secondColor thirdTheme:thirdColor];
}

- (void)dealloc {
    [_model release];
    _model = nil;
    _delegate = nil;
    [super dealloc];
}

//MARK: - Getters
- (Themes*)model {
    return _model;
}

- (id<ThemesViewControllerDelegate>)delegate {
    return _delegate;
}

//MARK: - Setters
- (void)setModel:(Themes *)model {
    if (_model != model) {
        [model retain];
        [_model release];
        _model = model;
    }
}

- (void)setDelegate:(id<ThemesViewControllerDelegate>)delegate {
    if (_delegate != delegate) {
        [delegate retain];
        [_delegate release];
        _delegate = delegate;
    }
}

//MARK: - IBActions
- (IBAction)tapCloseBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setTheme1:(UIButton *)sender {
    [_delegate themesViewController:self didSelectTheme:[self.model theme1Dark]];
    self.view.backgroundColor = [self.model theme1Dark];
    [[UINavigationBar appearance] setBackgroundColor: [self.model theme1Dark]];
}

- (IBAction)setTheme2:(UIButton *)sender {
    [_delegate themesViewController:self didSelectTheme:[self.model theme2Light]];
    self.view.backgroundColor = [self.model theme2Light];
    [[UINavigationBar appearance] setBackgroundColor: [self.model theme2Light]];
}

- (IBAction)setTheme3:(UIButton *)sender {
    [_delegate themesViewController:self didSelectTheme:[self.model theme3Pink]];
    self.view.backgroundColor = [self.model theme3Pink];
    [[UINavigationBar appearance] setBackgroundColor: [self.model theme3Pink]];
}

@end

