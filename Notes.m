//
//  Notes.m
//  Howdy
//
//  Created by Edan Lichtenstein on 3/31/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "Notes.h"

@implementation Notes


//UIDocumentInteractionController
/*
 NSURL *shareUrl = self.recorder.url;
 //  NSURL *shareUrl = [NSURL fileURLWithPath:[NSString stringWithFormat: @"%@",[[NSBundle mainBundle] self.recorder.url]]];
 
 if (shareUrl) {
 
 self.docController = [self setupControllerWithURL:shareUrl usingDelegate:self];
 
 //self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:shareUrl];
 NSLog(@"%@", shareUrl);
 
 // Configure Document Interaction Controller
 //[self.documentInteractionController setDelegate:self];
 //_documentInteractionController.delegate = self;
 
 // [self.documentInteractionController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
 [self.docController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
 
 // [self.documentInteractionController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
 
 }
 
 
 
 - (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
 return self;
 }
 
 
 
 - (UIDocumentInteractionController *) setupControllerWithURL:(NSURL *)fileURL usingDelegate:(id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
 
 UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
 interactionController.delegate = interactionDelegate;
 
 return interactionController;
 }
 
 
 
 - (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
 {
 return self.view;
 }
 
 - (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
 {
 return self.view.frame;
 }

 
 
 */


/*
 
 UI Activity Controller stuff:
 
@property UIActivityViewController *activityViewController;


NSString *shareString = @"Howdy Partner!!";
NSURL *shareUrl = self.recorder.url;
NSData *audioData = [NSData dataWithContentsOfURL:shareUrl];
NSArray *activityItems = [NSArray arrayWithObjects:shareUrl, shareString, nil];

if (shareUrl) {
    
    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    self.activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:self.activityViewController animated:YES completion:nil];
}

*/


@end
