//
//  HowdyTalkViewController.m
//  Howdy
//
//  Created by Edan Lichtenstein on 3/3/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "HowdyTalkViewController.h"
#import <MessageUI/MessageUI.h>
#import <OpenEars/LanguageModelGenerator.h>
#import <Parse/Parse.h>
#import "LogInViewController.h"
#import "Constants.h"
#import <FAKFontAwesome.h>
#import "UIColor+Colors.h"


//#import <UIView+DebugQuickLook.m>

@interface HowdyTalkViewController () <MFMailComposeViewControllerDelegate>


@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *recordingTimer;

@property (strong, nonatomic) IBOutlet UILabel *howdyLabel;



@property (strong, nonatomic) IBOutlet UIView *playBackView;
@property (strong, nonatomic) IBOutlet UIImageView *playBackImageView;
- (IBAction)playBackButtonTapped:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIView *emailVMView;
@property (strong, nonatomic) IBOutlet UIImageView *emailVMImageView;
- (IBAction)emailVMButtonTapped:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIView *pushVMView;
@property (strong, nonatomic) IBOutlet UIImageView *pushVMImageView;
- (IBAction)pushVMButtonTapped:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UILabel *recordLabel;
@property (strong, nonatomic) IBOutlet UIImageView *microphoneImageView;


@end

@implementation HowdyTalkViewController

@synthesize pocketsphinxController;
@synthesize openEarsEventsObserver;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];

    
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"%@", currentUser);
 //  PFUser *user = [PFUser logInWithUsername:@"Leroy Brown" password:@"Gene"];
 //  PFUser *user = [PFUser logInWithUsername:@"Edan" password:@"jam"];

    if (currentUser) {
        // do stuff with the user
    } else {
        
        PFUser *user = [PFUser user];
//        user.username = @"Leroy Brown";
//        user.password = @"Gene";
//        user.email = @"Leroy@example.com";

        user.username = @"Edan";
        user.password = @"jam";
        user.email = @"Edan@example.com";
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now.
            } else {
                NSString *errorString = [error userInfo][@"error"];
                // Show the errorString somewhere and let the user try again.
            }
        }];
//        NSString *storyboardName = @"Main";
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//        UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        [self.navigationController pushViewController:loginVC animated:YES];
    }


    [self associateDeviceWithUser];

    // Not yet ready for these two below.
    // [self setupNavigationBar];
    // [self openEars];
}


- (void) viewDidAppear:(BOOL)animated
{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Button Actions


- (IBAction)howdyButtonPressed:(UIButton *)sender{
    

    if (sender.selected) {
        [self stopRecording];
    } else {
        [self startRecording];
    }
    sender.selected = !sender.selected;
    
}

- (IBAction)playBackButtonTapped:(UIButton *)sender {
    
    //    [SimpleAudioPlayer playFile:_recorder.url.description];
    NSError* error = nil;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:&error];
    _player.volume = 1.0f;
    _player.numberOfLoops = 0;
    _player.delegate = self;
    [_player play];
    NSLog(@"duration: %f", _player.duration);
}

- (IBAction)shareVoiceMail:(UIButton *)sender{
    [self emailVoiceMail];
}

- (IBAction)emailVMButtonTapped:(UIButton *)sender {
    [self emailVoiceMail];
}

- (IBAction)pushVMButtonTapped:(UIButton *)sender {
    [self pushVoiceMessage];
}




- (IBAction)longPressed:(UILongPressGestureRecognizer *)gesture  {
    if(UIGestureRecognizerStateBegan == gesture.state) {
        NSLog(@"Gesture state began");
        [self startRecording];
    }
    
    if(UIGestureRecognizerStateChanged == gesture.state) {
    }
    
    if(UIGestureRecognizerStateEnded == gesture.state) {
        NSLog(@"Gesture state ended");
        [self stopRecording];
     }
}

- (void) recordingTimerUpdate:(id) sender
{
    NSLog(@"%f %@", _recorder.currentTime, sender);
    self.recordingLengthLabel.text = [NSString stringWithFormat:@"%.2f", _recorder.currentTime];
}


- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"did finish playing %d", flag);
}

-(void) associateDeviceWithUser
{
    PFInstallation *installation = [PFInstallation currentInstallation];
    installation[@"user"] = [PFUser currentUser];
    [installation saveInBackground];
}


#pragma mark Recording

-(void) startRecording
{

    NSDictionary* recorderSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInt:kAudioFormatAppleIMA4],AVFormatIDKey,
                                      [NSNumber numberWithInt:44100],AVSampleRateKey,
                                      [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                      [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                      nil];
    NSError* error = nil;
    

    
    
    NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *path = [applicationDocumentsDirectory URLByAppendingPathComponent:@"tmp.caf"];
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:path  settings:recorderSettings error:&error];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
   // UInt32 doChangeDefault = 1;
    //AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);
    
    self.recorder.delegate = self;
    [self.recorder record];
    self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(recordingTimerUpdate:) userInfo:nil repeats:YES];
    [_recordingTimer fire];
    
    self.recordingLengthLabel.backgroundColor = [UIColor redColor];
    

}

-(void) stopRecording
{
    self.recordingLengthLabel.backgroundColor = [UIColor clearColor];
    
    
    [self.recorder stop];
    [self.recordingTimer invalidate];
    self.recordingTimer = nil;
    NSLog(@"%@", self.recorder.url);
}



#pragma mark - Parse Communication


-(void) pushVoiceMessage
{
 
    NSURL *shareUrl = self.recorder.url;
    NSData *dataToSend = [[NSData alloc] initWithContentsOfURL:shareUrl];
    
 
    PFObject *voiceMail = [PFObject objectWithClassName:@"Voice_Mail"];
    [voiceMail setObject:@"Edan" forKey:@"Name"];
    [voiceMail setObject:@101 forKey:@"UniqueID"];
    [voiceMail setObject:dataToSend forKey:@"Audio_File"];
    
    [voiceMail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            NSLog(@"Voice Mail Uploaded with Object id %@",[voiceMail objectId]);
            [self sendPushWithID:[voiceMail objectId]];
        }
        else{
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"PFObject Sending Error: %@", errorString);
        }
    }];
    
}

-(void) sendPushWithID: (NSString *)voiceMailID
{

    NSDictionary *pushDataDictionary = [NSDictionary dictionaryWithObjectsAndKeys:voiceMailID, @"VoiceMailID", nil];
    NSLog(@"%@", voiceMailID);
    
    PFQuery *userQuery = [PFUser query];
//    [userQuery whereKey:@"username" containsString:@"Leroy Brown"];
    [userQuery whereKey:@"username" containsString:@"Edan"];
    //NSLog(@"%@",[userQuery getFirstObject]);
    
  
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user" matchesQuery:userQuery];
    //NSLog(@"%@", [pushQuery getFirstObject]);
    
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    [push setMessage:@"Testing the How to the dY."];
    [push setData:pushDataDictionary];
    [push sendPushInBackground];
    NSLog(@"Sent Push");
    
}




#pragma mark - Emailing Methods



-(void) emailVoiceMail
{

    //  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //  NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //    NSString *filepath = [documentsDirectory stringByAppendingPathComponent:memo.memoUrl];
    //    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filepath];
    
    NSURL *shareUrl = self.recorder.url;
    NSData *dataToSend = [[NSData alloc] initWithContentsOfURL:shareUrl];
    //    [fileURL release];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Voice Mail for you"];
    
    // Set up recipients
    NSArray *toRecipients = nil;
    NSArray *ccRecipients = nil;
    NSArray *bccRecipients = nil;
    
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    [picker setBccRecipients:bccRecipients];
    
    [picker setMessageBody:@"" isHTML:YES];
    [picker addAttachmentData:dataToSend mimeType:@"audio/x-caf" fileName: @"MyMessageToYou.caf"];
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}





#pragma mark - UI setup

-(void) createUI
{
    [self setupControllerButtons];
    [self drawRecordLabel];
    [self drawHowdyLabel];
    [self drawTimerLabel];
    
}
-(void) setupNavigationBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    searchBar.delegate = self;
    searchBar.placeholder = @"Find a Contact";
    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBarView;
}


-(void) setupControllerButtons
{
    //Create and draw Icons
    FAKFontAwesome *playIcon = [FAKFontAwesome playIconWithSize:50];
    FAKFontAwesome *emailIcon = [FAKFontAwesome envelopeOIconWithSize:45];
    FAKFontAwesome *iPhoneIcon = [FAKFontAwesome mobileIconWithSize:60];

    playIcon.drawingBackgroundColor = [UIColor clearColor];
    [playIcon addAttribute:NSForegroundColorAttributeName value:[UIColor purpleMagic]];
    self.playBackImageView.image = [playIcon imageWithSize:self.playBackImageView.frame.size];
    [self drawCircleInView:self.playBackView withColor:[UIColor purpleMagic]];
    
    emailIcon.drawingBackgroundColor = [UIColor clearColor];
    [emailIcon addAttribute:NSForegroundColorAttributeName value:[UIColor purpleLight]];
    self.emailVMImageView.image = [emailIcon imageWithSize:self.emailVMImageView.frame.size];
    [self drawCircleInView:self.emailVMView withColor:[UIColor purpleLight]];
    
    
    iPhoneIcon.drawingBackgroundColor = [UIColor clearColor];
    [iPhoneIcon addAttribute:NSForegroundColorAttributeName value:[UIColor purpleOcean]];
    self.pushVMImageView.image = [iPhoneIcon imageWithSize:self.pushVMImageView.frame.size];
    [self drawCircleInView:self.pushVMView withColor:[UIColor purpleOcean]];

}

-(void) drawCircleInView: (UIView *)view withColor:(UIColor *)color
{
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [view bounds].size.width, [view bounds].size.height)];
    [circleLayer setPosition:CGPointMake([view bounds].size.width/2.0f,
                                         [view bounds].size.height/2.0f)];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0.0f, 0.0f, [view bounds].size.width, [view bounds].size.height)];
    [circleLayer setPath:[path CGPath]];
    [circleLayer setStrokeColor:[color CGColor]];
    [circleLayer setLineWidth:3.0f];
    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    [[view layer] addSublayer:circleLayer];

}

-(void)drawRecordLabel
{
    FAKFontAwesome *microphoneIcon = [FAKFontAwesome microphoneIconWithSize:80];
    [microphoneIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    self.microphoneImageView.image = [microphoneIcon imageWithSize:self.microphoneImageView.frame.size];
    
    self.recordLabel.layer.borderColor = [UIColor purpleLight].CGColor;
    self.recordLabel.layer.backgroundColor = [UIColor silverCool].CGColor;
    self.recordLabel.layer.borderWidth = 5.0;
    
}

-(void)drawHowdyLabel
{
    self.howdyLabel.textColor = [UIColor purpleMagic];
}


-(void)drawTimerLabel
{
    self.recordingLengthLabel.textColor = [UIColor silverSimple];
}


#pragma mark - Open Ears

- (PocketsphinxController *)pocketsphinxController {
	if (pocketsphinxController == nil) {
		pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return pocketsphinxController;
}


- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}



-(void) openEars
{
    LanguageModelGenerator *lmGenerator = [[LanguageModelGenerator alloc] init];
    
    NSArray *words = [NSArray arrayWithObjects:@"BEGIN", @"BREAK" @"POSTMAN", @"LEROY BROWN", nil];
    NSString *name = @"NameIWantForMyLanguageModelFiles";
    NSError *err = [lmGenerator generateLanguageModelFromArray:words withFilesNamed:name forAcousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"]]; // Change "AcousticModelEnglish" to "AcousticModelSpanish" to create a Spanish language model instead of an English one.
    
    
    NSDictionary *languageGeneratorResults = nil;
    
    NSString *lmPath = nil;
    NSString *dicPath = nil;
	
    if([err code] == noErr) {
        
        languageGeneratorResults = [err userInfo];
		
        lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
		
    } else {
        NSLog(@"Error: %@",[err localizedDescription]);
    }

    [self.openEarsEventsObserver setDelegate:self];
    
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
    

}








#pragma mark Open Ears Delegate Methods

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)howdyCommand recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", howdyCommand, recognitionScore, utteranceID);
    
    //self.heardWordList.text = (@"%@ \n", howdyCommand);
    
    if ([howdyCommand isEqualToString:@"BEGIN"])
    {
        [self startRecording];
    }
    else if ([howdyCommand isEqualToString:@"END"])
    {
        [self stopRecording];
    }
    else if ([howdyCommand isEqualToString:@"POSTMAN"])
    {
        [self emailVoiceMail];
    }
}

- (void) pocketsphinxDidStartCalibration {
	NSLog(@"Pocketsphinx calibration has started.");
}

- (void) pocketsphinxDidCompleteCalibration {
	NSLog(@"Pocketsphinx calibration is complete.");
}

- (void) pocketsphinxDidStartListening {
	NSLog(@"Pocketsphinx is now listening.");
}

- (void) pocketsphinxDidDetectSpeech {
	NSLog(@"Pocketsphinx has detected speech.");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	NSLog(@"Pocketsphinx has detected a period of silence, concluding an utterance.");
}

- (void) pocketsphinxDidStopListening {
	NSLog(@"Pocketsphinx has stopped listening.");
}

- (void) pocketsphinxDidSuspendRecognition {
	NSLog(@"Pocketsphinx has suspended recognition.");
}

- (void) pocketsphinxDidResumeRecognition {
	NSLog(@"Pocketsphinx has resumed recognition.");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFail { // This can let you know that something went wrong with the recognition loop startup. Turn on OPENEARSLOGGING to learn why.
	NSLog(@"Setting up the continuous recognition loop has failed for some reason, please turn on OpenEarsLogging to learn more.");
}
- (void) testRecognitionCompleted {
	NSLog(@"A test file that was submitted for recognition is now complete.");
}



@end
