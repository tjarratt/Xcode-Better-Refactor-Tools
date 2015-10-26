#import "RefactorToolsModule.h"
#import "XMASRefactorMethodAction.h"
#import "XMASTokenizer.h"
#import "XMASAlert.h"
#import "XMASChangeMethodSignatureControllerProvider.h"
#import "XMASObjcMethodDeclarationParser.h"
#import "XMASXcodeTargetSearchPathResolver.h"
#import "XMASSearchPathExpander.h"
#import "XMASXcodeRepository.h"
#import "XMASObjcMethodDeclarationRewriter.h"
#import "XMASObjcMethodDeclarationStringWriter.h"
#import "XMASObjcCallExpressionRewriter.h"
#import "XMASMethodOccurrencesRepository.h"
#import "XMASWindowProvider.h"
#import "XMASObjcMethodCallParser.h"
#import "XMASObjcCallExpressionStringWriter.h"
#import "XMASObjcCallExpressionTokenFilter.h"
#import "XMASGenerateFakeAction.h"
#import "XMASFakeProtocolPersister.h"
#import "XMASCurrentSourceCodeDocumentProxy.h"
#import "XMASSelectedTextProxy.h"
#import "SwiftCompatibilityHeader.h"

static XMASRefactorMethodAction *action;

@implementation RefactorToolsModule

- (void)configure:(id<BSBinder>)binder {
    [binder bind:[XMASRefactorMethodAction class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        XMASXcodeRepository *xcodeRepository = [injector getInstance:[XMASXcodeRepository class]];
        id editor = [xcodeRepository currentEditor];

        if (action != nil) {
            [action setupWithEditor:editor];
            return action;
        }

        action = [[XMASRefactorMethodAction alloc] initWithAlerter:[injector getInstance:[XMASAlert class]]
                                                         tokenizer:[injector getInstance:[XMASTokenizer class]]
                                                controllerProvider:[injector getInstance:[XMASChangeMethodSignatureControllerProvider class]]
                                                  methodDeclParser:[injector getInstance:[XMASObjcMethodDeclarationParser class]]];

        [action setupWithEditor:editor];
        return action;
    }];

    [binder bind:[XMASGenerateFakeAction class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        return [[XMASGenerateFakeAction alloc] initWithAlerter:[injector getInstance:[XMASAlert class]]
                                             selectedTextProxy:[injector getInstance:@protocol(XMASSelectedTextProxy)]
                                         fakeProtocolPersister:[injector getInstance:[XMASFakeProtocolPersister class]]
                                       sourceCodeDocumentProxy:[injector getInstance:[XMASCurrentSourceCodeDocumentProxy class]]];
    }];

    [binder bind:[XMASTokenizer class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        XMASXcodeTargetSearchPathResolver *searchPathResolver = [injector getInstance:[XMASXcodeTargetSearchPathResolver class]];
        return [[XMASTokenizer alloc] initWithTargetSearchPathResolver:searchPathResolver
                                                       xcodeRepository:[injector getInstance:[XMASXcodeRepository class]]];
    }];

    [binder bind:[XMASXcodeTargetSearchPathResolver class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        XMASSearchPathExpander *searchPathExpander = [injector getInstance:[XMASSearchPathExpander class]];
        return [[XMASXcodeTargetSearchPathResolver alloc] initWithPathExpander:searchPathExpander];
    }];

    [binder bind:[XMASChangeMethodSignatureControllerProvider class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        return [[XMASChangeMethodSignatureControllerProvider alloc] initWithWindowProvider:[injector getInstance:[XMASWindowProvider class]]
                                                                                   alerter:[injector getInstance:[XMASAlert class]]
                                                               methodOccurrencesRepository:[injector getInstance:[XMASMethodOccurrencesRepository class]]
                                                                    callExpressionRewriter:[injector getInstance:[XMASObjcCallExpressionRewriter class]]
                                                             methodDeclarationStringWriter:[injector getInstance:[XMASObjcMethodDeclarationStringWriter class]]
                                                                 methodDeclarationRewriter:[injector getInstance:[XMASObjcMethodDeclarationRewriter class]]];
    }];

    [binder bind:[XMASMethodOccurrencesRepository class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        XMASXcodeRepository *xcodeRepository = [injector getInstance:[XMASXcodeRepository class]];
        XC(IDEWorkspaceWindowController) currentWorkspaceController = [xcodeRepository currentWorkspaceController];

        return [[XMASMethodOccurrencesRepository alloc] initWithWorkspaceWindowController:currentWorkspaceController
                                                                          xcodeRepository:xcodeRepository];
    }];

    [binder bind:[XMASObjcCallExpressionRewriter class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        return [[XMASObjcCallExpressionRewriter alloc] initWithAlerter:[injector getInstance:[XMASAlert class]]
                                                             tokenizer:[injector getInstance:[XMASTokenizer class]]
                                                  callExpressionParser:[injector getInstance:[XMASObjcMethodCallParser class]]
                                            callExpressionStringWriter:[injector getInstance:[XMASObjcCallExpressionStringWriter class]]];
    }];

    [binder bind:[XMASObjcMethodDeclarationRewriter class] toBlock:^id(NSArray *args, id<BSInjector> injector) {
        return [[XMASObjcMethodDeclarationRewriter alloc] initWithMethodDeclarationStringWriter:[injector getInstance:[XMASObjcMethodDeclarationStringWriter class]]
                                                                        methodDeclarationParser:[injector getInstance:[XMASObjcMethodDeclarationParser class]]
                                                                                      tokenizer:[injector getInstance:[XMASTokenizer class]]
                                                                                        alerter:[injector getInstance:[XMASAlert class]]];
    }];

    [binder bind:[XMASObjcMethodCallParser class] toBlock:^id(NSArray * args, id<BSInjector> injector) {
        return [[XMASObjcMethodCallParser alloc] initWithCallExpressionTokenFilter:[injector getInstance:[XMASObjcCallExpressionTokenFilter class]]];
    }];

    [binder bind:@protocol(XMASSelectedTextProxy) toClass:[XMASSelectedSwiftProtocolProxy class]];
}

@end
