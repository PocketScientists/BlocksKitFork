//
//  WKWebViewBlocksKitTest.m
//  BlocksKit Unit Tests
//

@import XCTest;
@import BlocksKit.Dynamic.UIKit;
#import <WebKit/WebKit.h>

@interface WKWebViewBlocksKitTest : XCTestCase <WKNavigationDelegate>

@end

@implementation WKWebViewBlocksKitTest {
    WKWebView *_subject;
	BOOL shouldStartLoadDelegate, didStartLoadDelegate, didFinishLoadDelegate, didFinishWithErrorDelegate;
}

- (void)setUp {
	_subject = [[WKWebView alloc] initWithFrame:CGRectZero];
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    shouldStartLoadDelegate = YES;
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    didStartLoadDelegate = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    didFinishLoadDelegate = YES;
}


- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    didFinishWithErrorDelegate = YES;
}

- (void)testShouldStartLoad {
	_subject.navigationDelegate = self;
	
	__block BOOL shouldStartLoadBlock = NO;
    WKNavigationAction *action = [WKNavigationAction init];
	_subject.bk_shouldStartLoadBlock = ^void(WKWebView *webView, WKNavigationAction *navigationAction, void (^)(WKNavigationActionPolicy)) {
		shouldStartLoadBlock = YES;
	};
    
    
    [_subject.bk_dynamicDelegate webView:_subject decidePolicyForNavigationAction:action decisionHandler:^(WKNavigationActionPolicy){}];

	
	XCTAssertTrue(shouldStartLoadBlock, @"Block handler was called");
	XCTAssertTrue(shouldStartLoadDelegate, @"Delegate was called");
}

- (void)testDidStartLoad {
	_subject.navigationDelegate = self;
	
	__block BOOL didStartLoadBlock = NO;
	_subject.bk_didStartLoadBlock = ^(WKWebView *view, WKNavigation *navigation) {
		didStartLoadBlock = YES;
	};
	
    [_subject.bk_dynamicDelegate webView:_subject didStartProvisionalNavigation:nil];
	
	XCTAssertTrue(didStartLoadBlock, @"Block handler was called");
	XCTAssertTrue(didStartLoadDelegate, @"Delegate was called");
}

- (void)testDidFinishLoad {
	_subject.navigationDelegate = self;
	
	__block BOOL didFinishLoadBlock = NO;
	_subject.bk_didFinishLoadBlock = ^(WKWebView *view, WKNavigation *navigation) {
		didFinishLoadBlock = YES;
	};
	
    [_subject.bk_dynamicDelegate webView:_subject didFinishNavigation:nil];
	
	XCTAssertTrue(didFinishLoadBlock, @"Block handler was called");
	XCTAssertTrue(didFinishLoadDelegate, @"Delegate was called");
}

- (void)testDidFinishWithError {
	_subject.navigationDelegate = self;
	
	__block BOOL didFinishWithErrorBlock = NO;
	_subject.bk_didFinishWithErrorBlock = ^(WKWebView *view, NSError *err) {
		didFinishWithErrorBlock = YES;
	};
	
    WKNavigation *action = [WKNavigation init];
    NSError *error = [NSError init];
    [_subject.bk_dynamicDelegate webView:_subject didFailNavigation:action withError:error];
	
	XCTAssertTrue(didFinishWithErrorBlock, @"Block handler was called");
	XCTAssertTrue(didFinishWithErrorDelegate, @"Delegate was called");
}

@end
