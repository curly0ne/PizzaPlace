//
//  PPActivityIndicatorFooterView.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/24/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPActivityIndicatorFooterView.h"

@implementation PPActivityIndicatorFooterView

#pragma mark - Constructor

+ (id)loadFooterView
{
	return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}


@end
