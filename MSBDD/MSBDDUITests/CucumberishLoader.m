//
//  CucumberishLoader.m
//  MSBDDUITests
//
//  Created by 陳其宏 on 2021/4/22.
//

#import <Foundation/Foundation.h>
#import "MSBDDUITests-swift.h"

__attribute__((constructor))
void CucumberishInit(){
    [CucumberishInitializer setupCucumberish];
}
