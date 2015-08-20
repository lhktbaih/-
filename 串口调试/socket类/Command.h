//
//  Command.h
//  ifish
//
//  Created by Ouyang Zhi on 13-6-18.
//  Copyright (c) 2013年 com.awe.ifish. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CommandDelegate <NSObject>

@required
//delegate自己定义
@end




@interface Command : NSObject<NSStreamDelegate>{
    
    id<CommandDelegate> delegate;
    
}

/*******   设置delegate   ******/
-(void)setDelegate:(id<CommandDelegate>) delega;

/*******   和WiFi模块建立socket连接   ******/
-(void) connectedToServer;

/*******   发送数据   ******/
-(void) sendCommand:(NSMutableArray *) dataArr;

/*******   关闭连接   ******/
-(void)close;

//这个地址是服务器的地址
@property(nonatomic,retain)NSString *sockaddr;

//端口号
@property(nonatomic,assign)int sockport;

@end
