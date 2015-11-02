#import "XMASGenerateFakeAction.h"
#import "XMASAlert.h"
#import "SwiftCompatibilityHeader.h"
#import "XMASFakeProtocolPersister.h"
#import "XMASCurrentSourceCodeDocumentProxy.h"
#import "XMASSelectedTextProxy.h"


@interface XMASGenerateFakeAction ()
@property (nonatomic, strong) XMASAlert *alerter;
@property (nonatomic, strong) id<XMASSelectedTextProxy> selectedTextProxy;
@property (nonatomic, strong) XMASFakeProtocolPersister *fakeProtocolPersister;
@property (nonatomic, strong) XMASCurrentSourceCodeDocumentProxy *sourceCodeDocumentProxy;
@end

@implementation XMASGenerateFakeAction

- (instancetype)initWithAlerter:(XMASAlert *)alerter
              selectedTextProxy:(id <XMASSelectedTextProxy>)selectedTextProxy
          fakeProtocolPersister:(XMASFakeProtocolPersister *)fakeProtocolPersister
        sourceCodeDocumentProxy:(XMASCurrentSourceCodeDocumentProxy *)sourceCodeDocumentProxy {
    if (self = [super init]) {
        self.alerter = alerter;
        self.selectedTextProxy = selectedTextProxy;
        self.fakeProtocolPersister = fakeProtocolPersister;
        self.sourceCodeDocumentProxy = sourceCodeDocumentProxy;
    }

    return self;
}

- (void)safelyGenerateFakeForProtocolUnderCursor {
    @try {
        [self generateFakeForProtocolUnderCursor];
    } @catch (NSException *e) {

    }
}

- (void)generateFakeForProtocolUnderCursor {
    NSString *currentFilePath = [self.sourceCodeDocumentProxy currentSourceCodeFilePath];
    if (![currentFilePath.pathExtension.lowercaseString isEqual: @"swift"]) {
        [self.alerter flashMessage:@"generate-fake only works with Swift source files"];
        return;
    }

    ProtocolDeclaration *selectedProtocol = [self.selectedTextProxy selectedProtocolInFile:currentFilePath];
    if (!selectedProtocol || [selectedProtocol.name isEqualToString:@""]) {
        [self.alerter flashMessage:@"put your cursor on a swift protocol to generate a fake for it"];
        return;
    }

    [self.alerter flashMessage:[NSString stringWithFormat:@"generating fake '%@'", selectedProtocol.name]];
    [self.fakeProtocolPersister persistFakeForProtocol:selectedProtocol nearSourceFile:currentFilePath];
}

#pragma mark - NSObject

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
