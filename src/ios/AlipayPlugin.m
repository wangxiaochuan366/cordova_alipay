#import "AlipayPlugin.h"

#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation AlipayPlugin

-(void)pluginInitialize{
    CDVViewController *viewController = (CDVViewController *)self.viewController;
    self.partner = [viewController.settings objectForKey:@"partner"];
}

- (void) pay:(CDVInvokedUrlCommand*)command
{
    self.currentCallbackId = command.callbackId;

    NSString *args = [command argumentAtIndex:0];
        

    [[AlipaySDK defaultService] payOrder:args fromScheme:[NSString stringWithFormat:@"a%@", self.partner] callback:^(NSDictionary *resultDic) {
        if ([[resultDic objectForKey:@"resultStatus"]  isEqual: @"9000"]) {
            [self successWithCallbackID:self.currentCallbackId messageAsDictionary:resultDic];
        } else {
            [self failWithCallbackID:self.currentCallbackId messageAsDictionary:resultDic];
        }
        
        NSLog(@"reslut = %@",resultDic);
    }];
}

- (void)handleOpenURL:(NSNotification *)notification
{
    NSURL* url = [notification object];
    
    if ([url isKindOfClass:[NSURL class]] && [url.scheme isEqualToString:[NSString stringWithFormat:@"a%@", self.partner]])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if ([[resultDic objectForKey:@"resultStatus"]  isEqual: @"9000"]) {
                [self successWithCallbackID:self.currentCallbackId messageAsDictionary:resultDic];
            } else {
                [self failWithCallbackID:self.currentCallbackId messageAsDictionary:resultDic];
            }
        }];
    }
}

- (void)successWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}

- (void)failWithCallbackID:(NSString *)callbackID withMessage:(NSString *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}
- (void)successWithCallbackID:(NSString *)callbackID messageAsDictionary:(NSDictionary *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}

- (void)failWithCallbackID:(NSString *)callbackID messageAsDictionary:(NSDictionary *)message
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:message];
    [self.commandDelegate sendPluginResult:commandResult callbackId:callbackID];
}

@end
