//
//  NSTimer+BBlocks.m
//  BBlock
//
//  Created by David Keegan on 3/12/12.
//  Copyright 2012 David Keegan. All rights reserved.
//

#import "NSTimer+BBlocks.h"

@interface NSTimer(BBlockPrivate)
+ (void)executeBlock:(NSTimer *)timer;
@end

@implementation NSTimer(BBlocks)

+ (void)executeBlock:(NSTimer *)timer{
    if([timer userInfo]){
        void (^block)() = (void (^)())[timer userInfo];
        block();
    }
}

+ (id)timerWithTimeInterval:(NSTimeInterval)timeInterval andBlock:(void (^)())block{
    return [[self class] timerRepeats:NO withTimeInterval:timeInterval andBlock:block];
}

+ (id)timerRepeats:(BOOL)repeats withTimeInterval:(NSTimeInterval)timeInterval andBlock:(void (^)())block{
    void (^_block)() = [block copy];
    id timer = [self timerWithTimeInterval:timeInterval 
                                    target:self 
                                  selector:@selector(executeBlock:) 
                                  userInfo:_block 
                                   repeats:repeats];
#if !__has_feature(objc_arc)
    [_block release];
#endif
    return timer;
}

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval andBlock:(void (^)())block{
    return [[self class] scheduledTimerRepeats:NO withTimeInterval:timeInterval andBlock:block];
}

+ (id)scheduledTimerRepeats:(BOOL)repeats withTimeInterval:(NSTimeInterval)timeInterval andBlock:(void (^)())block{
    void (^_block)() = [block copy];
    id timer = [self scheduledTimerWithTimeInterval:timeInterval 
                                             target:self 
                                           selector:@selector(executeBlock:) 
                                           userInfo:_block 
                                            repeats:repeats];
#if !__has_feature(objc_arc)
    [_block release];
#endif
    return timer;
}

@end
