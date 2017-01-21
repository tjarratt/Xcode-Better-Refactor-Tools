#import <Foundation/Foundation.h>

@class XMASLogger;
@class XMASSelectedTextProxy;
@class XMASFakeProtocolPersister;
@class XMASParseSelectedProtocolWorkFlow;

@protocol XMASAlerter;
@protocol XMASSelectedSourceFileOracle;
@protocol XMASAddFileToXcodeProjectWorkflow;

NS_ASSUME_NONNULL_BEGIN

@interface XMASGenerateFakeForSwiftProtocolUseCase : NSObject

- (instancetype)initWithAlerter:(id<XMASAlerter>)alerter
                         logger:(XMASLogger *)logger
              parseSelectedProtocolWorkFlow:(XMASParseSelectedProtocolWorkFlow *)selectedProtocolWorkFlow
          fakeProtocolPersister:(XMASFakeProtocolPersister *)fakeProtocolPersister
       selectedSourceFileOracle:(id<XMASSelectedSourceFileOracle>)selectedSourceFileOracle
                addFileWorkflow:(nullable id<XMASAddFileToXcodeProjectWorkflow>)addFileWorkflow NS_DESIGNATED_INITIALIZER;

- (void)safelyGenerateFakeForSelectedProtocol;

@property (nonatomic, readonly) XMASLogger *logger;
@property (nonatomic, readonly) id<XMASAlerter> alerter;
@property (nonatomic, readonly) XMASFakeProtocolPersister *fakeProtocolPersister;
@property (nonatomic, readonly) id<XMASSelectedSourceFileOracle> selectedSourceFileOracle;
@property (nonatomic, readonly) XMASParseSelectedProtocolWorkFlow *selectedProtocolWorkFlow;
@property (nonatomic, readonly, nullable) id<XMASAddFileToXcodeProjectWorkflow> addFileWorkflow;

@end

@interface XMASGenerateFakeForSwiftProtocolUseCase (UnavailableInitializers)

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END;
