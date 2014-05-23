//
//  ChikubiSaverView.m
//  ChikubiSaver
//
//  Created by DN on 2014/05/03.
//
//

#import "ChikubiSaverView.hpp"

#include <algorithm>

@implementation ChikubiSaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:0.3];

        NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] visibleFrame];
        width = screenRect.size.width;
        height = screenRect.size.height;
        fontsize = height / 40;
        
        float c = [@"a" sizeWithAttributes:
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSFont fontWithName:@"Menlo" size:fontsize], NSFontAttributeName,nil]].width;
        
        strmax = width / c;
        beammax = (strmax - 3) / 4;
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
    state = 0;
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    char s[strmax + 1];
    strncpy(s, "| o   o |", 9);
    for(unsigned i = 9; i < strmax; ++i)
        s[i] = ' ';
    s[strmax] = '\0';
    
    for(unsigned i = 0; i < beamc; ++i){
        for(unsigned j = 0; j < 3; ++j){
            unsigned idx = j + state + i * 4;
            if(3 <= idx && idx < strmax)
                s[idx] = '-';
            idx += 4;
            if(7 <= idx && idx < strmax)
                s[idx] = '-';
        }
    }
    
    if(state == 3)
        beamc = std::min(beamc + 1, beammax);
    state = (state + 1) % 4;
    
    [[NSColor blackColor] set];
    [NSBezierPath fillRect:NSMakeRect(0, 0, width, height)];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[[NSString alloc] initWithUTF8String:s]];
    [string addAttribute:NSFontAttributeName value:[NSFont fontWithName:@"Menlo" size:fontsize] range:NSMakeRange(0, strmax-1)];
    [string addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, strmax-1)];
    [string drawAtPoint:NSMakePoint(0.f, height / 2)];
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end
