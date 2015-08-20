//
//  Command.m
//  ifish
//
//  Created by Ouyang Zhi on 13-6-18.
//  Copyright (c) 2013年 com.awe.ifish. All rights reserved.
//

#import "Command.h"




@interface Command(){
    NSInputStream * cmdInputStream;
    NSOutputStream * cmdOutputStream;
    int cmdConnected;
    NSString * cameraaddress;
    
}

@end

@implementation Command

/*******   初始化   ******/
- (id) init {
    
    self = [super init];
    if(self){
        cmdConnected = 0;
    }
    
    return self;
    
}

/*******   设置delegate   ******/
-(void)setDelegate:(id<CommandDelegate>) delega{
    
    delegate = delega;
    
}

/*******   接受数据   ******/
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode{

    switch(eventCode) {
		case NSStreamEventOpenCompleted:
            cmdConnected = 1;
            break;
		case NSStreamEventHasBytesAvailable:
            if (stream == cmdInputStream) {
                uint8_t buffer[1024];
                int len;
                while ([cmdInputStream hasBytesAvailable]) {
                    
                    len = (int)[cmdInputStream read:buffer maxLength:sizeof(buffer)];
                    
                    //输出得到的数据
                    printf("recive");
                    for(int i = 0; i<len;i++){
                        printf(" %02x",buffer[i]);
                    }
                    printf("\n");

                }
            }

			break;
		case NSStreamEventErrorOccurred:
            break;
        case NSStreamEventNone:
        case NSStreamEventHasSpaceAvailable:
        case NSStreamEventEndEncountered:
			break;
			
    }
}

/*******   发送数据   ******/
-(void) sendCommand:(NSMutableArray *) dataArr{

    int len=(int)[dataArr count];
    
    uint8_t buf[len];

    for (int i=0; i<len; i++) {
        
        buf[i]=[[dataArr objectAtIndex:i] integerValue];
        
    }

    [cmdOutputStream write:buf maxLength:len];
    
}

/*******   和WiFi模块建立socket连接   ******/
-(void) connectedToServer{

	NSLog(@"cmdConnectedToServer run");
	if(!cmdConnected){

		CFReadStreamRef readStream;
		CFWriteStreamRef writeStream;
		
		CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)_sockaddr, _sockport, &readStream, &writeStream);
		if(!readStream){
			NSLog(@"Create Connection error");
			return;
		}

		cmdInputStream = (__bridge NSInputStream *)readStream;
		cmdOutputStream = (__bridge NSOutputStream *)writeStream;
		[cmdInputStream setDelegate:self];
		[cmdOutputStream setDelegate:self];
		[cmdInputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[cmdOutputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
		[cmdInputStream open];
		[cmdOutputStream open];
    }
    
}

/*******   关闭连接   ******/
-(void)close{
    
    if(cmdConnected ){
        cmdConnected = 0;
        [cmdOutputStream close];
        
        [cmdOutputStream removeFromRunLoop:[NSRunLoop currentRunLoop]

                                 forMode:NSDefaultRunLoopMode];

        [cmdOutputStream setDelegate:nil];
        
        [cmdInputStream close];
        
        [cmdInputStream removeFromRunLoop:[NSRunLoop currentRunLoop]
         
                                forMode:NSDefaultRunLoopMode];
        
        [cmdInputStream setDelegate:nil];
    }
    
}

@end
