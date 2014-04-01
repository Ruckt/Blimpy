//
//  HowdyTalkViewController.m
//  Howdy
//
//  Created by Edan Lichtenstein on 3/3/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "HowdyTalkViewController.h"
#import <MessageUI/MessageUI.h>

@interface HowdyTalkViewController () <MFMailComposeViewControllerDelegate>


@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *recordingTimer;
//@property (nonatomic, strong) UIView *controlsBg;

@property LanguageModelGenerator *lmGenerator;




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
    
    
    self.lmGenerator = [[LanguageModelGenerator alloc] init];

    
    
    [self.openEarsEventsObserver setDelegate:self];
    [self.pocketsphinxController startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO]; }


- (void) viewDidAppear:(BOOL)animated
{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions


- (IBAction)howdyButtonPressed:(UIButton *)sender{
    

    if (sender.selected) {
        // stop
        [self.recorder stop];
        [self.recordingTimer invalidate];
        self.recordingTimer = nil;
        NSLog(@"%@", self.recorder.url);
    } else {
        [self startRecording];
    }
    sender.selected = !sender.selected;
    
}
- (IBAction)playBackButtonPressed:(UIButton *)sender
{
    //    [SimpleAudioPlayer playFile:_recorder.url.description];
    NSError* error = nil;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:&error];
    _player.volume = 1.0f;
    _player.numberOfLoops = 0;
    _player.delegate = self;
    [_player play];
    NSLog(@"duration: %f", _player.duration);
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
        
        [self.recorder stop];
        [self.recordingTimer invalidate];
        self.recordingTimer = nil;
        NSLog(@"%@", self.recorder.url);

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
    UInt32 doChangeDefault = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(doChangeDefault), &doChangeDefault);
    
    self.recorder.delegate = self;
    [self.recorder record];
    self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(recordingTimerUpdate:) userInfo:nil repeats:YES];
    [_recordingTimer fire];
    

}




#pragma mark - Emailing Methods

- (IBAction)shareVoiceMail:(UIButton *)sender {

    
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

#pragma mark Open Ears

-(void) openEars
{
    NSArray *words = [NSArray arrayWithObjects:@"WORD", @"STATEMENT", @"OTHER WORD", @"A PHRASE", nil];
    NSString *name = @"NameIWantForMyLanguageModelFiles";
    
    NSError *err = [self.lmGenerator generateLanguageModelFromArray:words withFilesNamed:name forAcousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"]];
    
    
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
}

- (PocketsphinxController *)pocketsphinxController {
	if (pocketsphinxController == nil) {
        self.pocketsphinxController = [[PocketsphinxController alloc] init];
	}
	return self.pocketsphinxController;
}

- (OpenEarsEventsObserver *)openEarsEventsObserver {
	if (openEarsEventsObserver == nil) {
		openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
	}
	return openEarsEventsObserver;
}





#pragma mark Open Ears Delegate Methods

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"The received hypothesis is %@ with a score of %@ and an ID of %@", hypothesis, recognitionScore, utteranceID);
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
