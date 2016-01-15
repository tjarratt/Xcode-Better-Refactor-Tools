import Foundation
import BetterRefactorToolsKit

@objc class SelectedProtocolOracle : NSObject, XMASSelectedProtocolOracle {
    let protocolToFake: String?

    init(protocolToFake: String? = nil) {
        self.protocolToFake = protocolToFake
    }

    @objc func isProtocolSelected(protocolDecl : ProtocolDeclaration) -> Bool {
        return protocolToFake == nil || protocolToFake == protocolDecl.name
    }
}

@objc class SelectedSourceFileOracle : NSObject, XMASSelectedSourceFileOracle {
    let selectedSourceFilePath: String

    init(selectedSourceFilePath: String) {
        self.selectedSourceFilePath = selectedSourceFilePath
    }

    @objc func selectedFilePath() -> String {
        return selectedSourceFilePath
    }
}
