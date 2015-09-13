//
//  URLParser.h
//  HybridDemo
//
//  Created by Yaqing Wang on 9/13/15.
//  Copyright © 2015 billwang1990.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLParser : NSObject

@property (nonatomic, retain) NSArray *variables;

- (id)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;

@end