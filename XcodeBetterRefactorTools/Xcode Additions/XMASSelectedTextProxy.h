#import <Foundation/Foundation.h>

@class ProtocolDeclaration;

@protocol XMASSelectedTextProxy <NSObject>

- (ProtocolDeclaration *)selectedProtocolInFile:(NSString *)fileName error:(NSError **)error;

@end
