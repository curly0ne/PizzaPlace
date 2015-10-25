//
//  PPPlaceDetailsTableViewCell.m
//  PizzaPlace
//
//  Created by Dmytro Lutsenko on 10/20/15.
//  Copyright © 2015 Company. All rights reserved.
//

#import "PPPlaceDetailsTableViewCell.h"
#import "NSAttributedString+CCLFormat.h"


@interface PPPlaceDetailsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *attribute;
@property (weak, nonatomic) IBOutlet UILabel *value;

- (NSAttributedString *)makeHyperlinkFromString:(NSString *)string;
- (NSAttributedString *)makeStringUnderlined:(NSString *)string;

- (void)configureTapGestureRecognizerForLabel:(UILabel *)label withAction:(SEL)action;
- (void)URLLabelTapped:(id)sender;

@end

@implementation PPPlaceDetailsTableViewCell

#pragma mark - Setup

- (void)setupWithPlaceAttribute:(NSDictionary *)attribute
{
	NSString *attributeKey = attribute[@"key"];
	id attributeValue = attribute[@"value"];
	
	if ([[attributeKey lowercaseString] isEqualToString:@"menuurl"])
	{
		attributeKey = @"menu";
		attributeValue = [self makeHyperlinkFromString:attributeValue];
		[self configureTapGestureRecognizerForLabel:[self value] withAction:@selector(URLLabelTapped:)];
	}
	else if ([[attributeKey lowercaseString] isEqualToString:@"url"])
	{
		attributeKey = @"web";
		attributeValue = [self makeHyperlinkFromString:attributeValue];
		[self configureTapGestureRecognizerForLabel:[self value] withAction:@selector(URLLabelTapped:)];
	}
	else if ([[attributeKey lowercaseString] isEqualToString:@"phone"])
	{
		attributeValue = [self makeStringUnderlined:attributeValue];
		[self configureTapGestureRecognizerForLabel:[self value] withAction:@selector(URLLabelTapped:)];
	}
	else if ([[attributeKey lowercaseString] isEqualToString:@"distance"])
	{
		[[self value] setAttributedText:[NSAttributedString attributedStringWithFormat:@"%@ meters", attributeValue]];
		return;
	}
	
	[[self attribute] setText:[attributeKey capitalizedString]];
	[[self value] setAttributedText:[NSAttributedString attributedStringWithFormat:@"%@", attributeValue]];
}

#pragma mark - Private

- (NSAttributedString *)makeHyperlinkFromString:(NSString *)string
{
	NSDictionary *formatAttributes = @{NSLinkAttributeName : string,
									   NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],
									   NSForegroundColorAttributeName : [UIColor colorWithRed:111.f green:113.f blue:121.f alpha:1.f]};
	
	return [[NSAttributedString alloc] initWithString:string attributes:formatAttributes];
}

- (NSAttributedString *)makeStringUnderlined:(NSString *)string
{
	NSDictionary *formatAttributes = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
	
	return [[NSAttributedString alloc] initWithString:string attributes:formatAttributes];
}

- (void)configureTapGestureRecognizerForLabel:(UILabel *)label withAction:(SEL)action
{
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
																					action:action];
	
	[label addGestureRecognizer:tapRecognizer];
}

- (void)URLLabelTapped:(id)sender
{
	NSString *URLlabelValue = [NSString stringWithFormat:@"%@", [[self value] text]];
	NSString *URLLabelName = [[self attribute] text];
	NSString *URLPrefix = @"";
	
	if ([[URLLabelName lowercaseString] isEqualToString:@"phone"])
		URLPrefix = @"telprompt://";

	NSURL *url = [NSURL URLWithString:[URLPrefix stringByAppendingString:URLlabelValue]];
	
	if ([[UIApplication sharedApplication] canOpenURL:url])
	{
		[[UIApplication sharedApplication] openURL:url];
	}
}

@end
