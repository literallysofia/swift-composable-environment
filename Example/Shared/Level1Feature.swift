import ComposableArchitecture
import ComposableEnvironment
import SwiftUI

struct Level1State: Equatable {
  var first: Level2State
  var second: Level2State
}

enum Level1Action {
  case first(Level2Action)
  case second(Level2Action)
}

class Level1Environment: ComposableEnvironment {
  @DerivedEnvironment<Level2Environment> var first
  @DerivedEnvironment<Level2Environment> var second
  
  // In this case, we could have used a shared DerivedEnvironment property instead:
  // @DerivedEnvironment<Level2Environment> var level2
  
  // This environment doesn't have exposed dependencies, but this doesn't prevent derived
  // environments to inherit dependencies that were set higher in the parents' chain, nor
  // to access them using their global KeyPath.
}

let level1Reducer = Reducer<Level1State, Level1Action, Level1Environment>.combine(
  level2Reducer.pullback(state: \.first,
                         action: /Level1Action.first,
                         environment: \.first), // (or \.level2 if we had used only one property)
  
  level2Reducer.pullback(state: \.second,
                         action: /Level1Action.second,
                         environment: \.second) // (or \.level2 if we had used only one property)
)

#if os(macOS)
fileprivate typealias Stack = HStack
#else
fileprivate typealias Stack = VStack
#endif

struct Level1View: View {
  let store: Store<Level1State, Level1Action>
  init(store: Store<Level1State, Level1Action>) {
    self.store = store
  }

  var body: some View {
    Stack {
      VStack {
        Text("First random number")
          .font(.title3)
        Level2View(store: store.scope(state: \.first, action: Level1Action.first))
          .padding()
      }
      VStack {
        Text("Second random number")
          .font(.title3)
        Level2View(store: store.scope(state: \.second, action: Level1Action.second))
          .padding()
      }
    }
  }
}

struct Level1View_Preview: PreviewProvider {
  static var previews: some View {
    Level1View(store:
      .init(initialState:
        .init(
          first: .init(randomNumber: 6),
          second: .init(randomNumber: nil)
        ),
        reducer: level1Reducer,
        environment: .init())
    )
  }
}
