//
//  ViewController.m
//  BlocBroswer
//
//  Created by Kenneth Chou on 5/25/16.
//  Copyright © 2016 Kenneth Chou. All rights reserved.
//

#import "ViewController.h"
#import "WebKit/WebKit.h"
#import "AwesomeFloatingToolbar.h"

//@interface ViewController () <WKNavigationDelegate, UITextFieldDelegate>
@interface ViewController () <WKNavigationDelegate, UITextFieldDelegate, AwesomeFloatingToolbarDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UITextField *textField;

//We use awesomeToolbar to replace these properties, back, forward, stop, reload.
//@property (nonatomic, strong) UIButton *backButton;
//@property (nonatomic, strong) UIButton *forwardButton;
//@property (nonatomic, strong) UIButton *stopButton;
//@property (nonatomic, strong) UIButton *reloadButton;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) AwesomeFloatingToolbar *awesomeToolbar;
@property (nonatomic, assign) NSUInteger frameCount;




#define kWebBrowserBackString NSLocalizedString(@"Back", @"Back command")
#define kWebBrowserForwardString NSLocalizedString(@"Forward", @"Forward command")
#define kWebBrowserStopString NSLocalizedString(@"Stop", @"Stop command")
#define kWebBrowserRefreshString NSLocalizedString(@"Refresh", @"Reload command")
@end

@implementation ViewController

#pragma mark - UIViewController

-(void) resetWebView{
    [self.webView removeFromSuperview];
    
    WKWebView *newWebview = [[WKWebView alloc] init];
    newWebview.navigationDelegate = self;
    [self.view addSubview:newWebview];

    self.webView = newWebview;
    
//    addButtonTargets method is no longer used after awesomeToolbar
//    [self addButtonTargets];
    
    self.textField.text = nil;
    [self updateButtonsAndTitle];
}

// addButtonTargets method is no longer used after awesomeToolbar
//- (void) addButtonTargets {
//    for (UIButton *button in @[self.backButton, self.forwardButton, self.stopButton, self.reloadButton]) {
//        [button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    [self.backButton addTarget:self.webView action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.forwardButton addTarget:self.webView action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
//    [self.stopButton addTarget:self.webView action:@selector(stopLoading) forControlEvents:UIControlEventTouchUpInside];
//    [self.reloadButton addTarget:self.webView action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
//}


- (void) loadView {
    UIView *mainView = [UIView new];
    self.webView = [[WKWebView alloc] init];
    self.webView.navigationDelegate = self;
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Welcome to Bloc Browser", @"Welcome to Bloc Brower") message:@"Enjoy browsing it" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Hello", nil) style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];


    [self presentViewController:alert animated:YES completion:nil];
    
    self.textField = [[UITextField alloc] init];
    self.textField.keyboardType = UIKeyboardTypeURL;
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    //self.textField.placeholder = NSLocalizedString(@"Website URL", @"Placeholder text for web browser URL field");
    //This is for chapter 23 assignment
    self.textField.placeholder = [NSString stringWithFormat:@"The user can also search"];
    self.textField.backgroundColor = [UIColor colorWithWhite:220/255.0f alpha:1];
    self.textField.delegate = self;
    

    self.awesomeToolbar = [[AwesomeFloatingToolbar alloc] initWithFourTitles:@[kWebBrowserBackString, kWebBrowserForwardString, kWebBrowserStopString, kWebBrowserRefreshString]];
    self.awesomeToolbar.delegate = self;
    
    
        for (UIView *viewToAdd in @[self.webView, self.textField, self.awesomeToolbar]) {

           [mainView addSubview:viewToAdd];
    }
    self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    
    

    //This method will have activityIndicator keeps spinning no matter the page is stilling loading.
    //[self.activityIndicator startAnimating];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //We use it to replace from CGFloat currentButtonX = 0; to currentButtonX += buttonWidth;
    self.awesomeToolbar.frame = CGRectMake(70, 100, 280, 60);

}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //make the webview fill the main view
    //self.webView.frame = self.view.frame;
    
    //First, calculate some dimensions.
    static const CGFloat itemHeight = 50;
    CGFloat width = CGRectGetWidth(self.view.bounds);
   
    //We use it to replace CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight - itemHeight; and CGFloat buttonWidth = CGRectGetWidth(self.view.bounds) / 4;

    CGFloat browserHeight = CGRectGetHeight(self.view.bounds) - itemHeight;

    //Now, assign the frames.
    self.textField.frame = CGRectMake(0, 0, width, itemHeight);
    self.webView.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame), width, browserHeight);
    
    

    
//    CGFloat currentButtonX = 0;
  
}

#pragma mark - UITextFieldDelegate


- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    NSString *URLString = self.textField.text;
    NSURL *URL = [NSURL URLWithString:URLString];
    
    
    
    if(!URL.scheme) {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", URLString]];
    }
    
    if(URL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [self.webView loadRequest:request];
    }
    
    //This is for chapter 23 assignment
    if ([URLString rangeOfString:@" "].location > 0) {
        NSString *urlString = [URLString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://google.com/search?q=%@", urlString]];
        NSURLRequest *stringRequest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:stringRequest];
        
    }
    

    return NO;
}

#pragma mark - WKNavigationDelegate

- (void) webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self updateButtonsAndTitle];
}

- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self updateButtonsAndTitle];
    
    }

- (void) webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error{
    [self webView:webView didFailNavigation:navigation withError:error];
}

- (void) webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if (error.code != NSURLErrorCancelled) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", @"Error") message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [self updateButtonsAndTitle];
}

#pragma mark - Miscellaneous
- (void) updateButtonsAndTitle {
    NSString *webPageTitle = [self.webView.title copy];
    if ([webPageTitle length]) {
        self.title = webPageTitle;
    }else{
        self.title = self.webView.URL.absoluteString;
    }
    
    if (self.webView.isLoading) {
        [self.activityIndicator startAnimating];
    }else{
        [self.activityIndicator stopAnimating];
    }
    //We use those to replace from self.backButton.enabled = [self.webView canGoBack]; to self.reloadButton.enabled = !self.webView.isLoading && self.webView.URL;
    [self.awesomeToolbar setEnabled:[self.webView goBack] forButtonWithTitle:kWebBrowserBackString];
    [self.awesomeToolbar setEnabled:[self.webView canGoForward] forButtonWithTitle:kWebBrowserForwardString];
    [self.awesomeToolbar setEnabled:[self.webView isLoading] forButtonWithTitle:kWebBrowserStopString];
    [self.awesomeToolbar setEnabled:![self.webView isLoading] && self.webView.URL forButtonWithTitle:kWebBrowserRefreshString];
}

#pragma mark - AwesomeFloatingToolbarDelegate

-(void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title {
    if ([title isEqual:kWebBrowserBackString]) {
        [self.webView goBack];
    }else if ([title isEqual:kWebBrowserBackString]) {
        [self.webView goForward];
    } else if ([title isEqual:NSLocalizedString(@"Stop", @"Stop command")]) {
        [self.webView stopLoading];
    } else if ([title isEqual:NSLocalizedString(@"Refresh", @"Reload command")]) {
        [self.webView reload];
    }
}

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset {
    CGPoint startingPoint = toolbar.frame.origin;
    CGPoint newPoint = CGPointMake(startingPoint.x + offset.x, startingPoint.y + offset.y);
    
    CGRect potentialNewFrame = CGRectMake(newPoint.x, newPoint.y, CGRectGetWidth(toolbar.frame), CGRectGetHeight(toolbar.frame));
    
    if (CGRectContainsRect(self.view.bounds, potentialNewFrame)) {
        toolbar.frame = potentialNewFrame;
    }
}

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPinchWithScale:(CGFloat)scale {
    CGPoint startingPoint = toolbar.frame.origin;
    
    CGRect potentialNewFrame = CGRectMake(startingPoint.x, startingPoint.y, CGRectGetWidth(toolbar.frame)*scale, CGRectGetHeight(toolbar.frame)*scale);
    
    if (CGRectContainsRect(self.view.bounds, potentialNewFrame)) {
        toolbar.frame = potentialNewFrame;
    }
}

@end






















