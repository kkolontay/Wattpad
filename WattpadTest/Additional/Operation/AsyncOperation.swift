import Foundation

class AsyncOperation: Operation {
  enum State: String {
    case Ready, Executing, Finished, Cancelled
    fileprivate var keyPath: String {
      return "is" + rawValue
    }
  }
  
  var state: State = State.Ready {
    willSet {
      willChangeValue(forKey: newValue.keyPath)
      willChangeValue(forKey: state.keyPath)
    }
    didSet {
      didChangeValue(forKey: oldValue.keyPath)
      didChangeValue(forKey: state.keyPath)
    }
  }
}

extension AsyncOperation {
  override var isReady: Bool {
    return super.isReady && state == .Ready
  }
  
  override var isExecuting: Bool {
    return state == .Executing
  }
  
  override var isFinished: Bool {
    return  state == .Finished
  }
  
  override var isCancelled: Bool {
    return state == .Cancelled
  }
  
  override var isAsynchronous: Bool {
    return true
  }
  
  override func start() {
    if isCancelled {
      self.state = .Finished
      return
    }
    main()
    self.state = .Executing
  }
  
  override func cancel() {
    self.state = .Cancelled
  }
}
