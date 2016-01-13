import Foundation
import BetterRefactorToolsKit

@objc class TerminalAlerter : NSObject, XMASAlerter {
    @objc func flashMessage(message: String!, withImage imageName: XMASAlertImage, shouldLogMessage: Bool) {
        print(message)
    }

    @objc func flashComfortingMessageForError(error: NSError!) {
        print("Error: \(error.localizedDescription)")
    }

    @objc func flashComfortingMessageForException(exception: NSException!) {
        print("2spooky5me")
    }
}
