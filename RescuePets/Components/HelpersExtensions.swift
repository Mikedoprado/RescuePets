//
//  HelpersExtensions.swift
//  RescuePets
//
//  Created by Michael do Prado on 8/11/21.
//

import Combine

// allow to remove the leaks in the combine assign
extension Publisher where Failure == Never {
//    func weakAssign<T: AnyObject>(
//        to keyPath: ReferenceWritableKeyPath<T, Output>,
//        on object: T
//    ) -> AnyCancellable {
//        sink { [weak object] value in
//            object?[keyPath: keyPath] = value
//        }
//    }
    func weakAssign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
      sink { [weak root] in
        root?[keyPath: keyPath] = $0
      }
    }
}
