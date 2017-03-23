import Foundation

// this file was generated by fake4swift
// https://github.com/tjarratt/fake4swift

struct FakeMyMutatingProtocol : MyMutatingProtocol, Equatable {
    fileprivate let hash: Int = Int(arc4random())

    init() {
    }

    fileprivate(set) var mutableMethodCallCount : Int = 0
    var mutableMethodStub : ((String, String) -> (String))?
    fileprivate var mutableMethodArgs : Array<(String, String)> = []
    mutating func mutableMethodReturns(stubbedValues: (String)) {
        self.mutableMethodStub = {(arg: String, arg2: String) -> (String) in
            return stubbedValues
        }
    }
    func mutableMethodArgs(forCall callIndex: Int) -> (String, String) {
        return self.mutableMethodArgs[callIndex]
    }
    mutating func mutableMethod(arg: String, arg2: String) -> (String) {
        guard let stub = self.mutableMethodStub else {
            fatalError("Fatal Error: You forgot to stub mutableMethod. Crashing. 💥")
        }
        self.mutableMethodCallCount += 1
        self.mutableMethodArgs.append((arg, arg2))
        return stub(arg, arg2)
    }

    static func reset() {
    }
}

func == (a: FakeMyMutatingProtocol, b: FakeMyMutatingProtocol) -> Bool {
    return a.hash == b.hash
}

