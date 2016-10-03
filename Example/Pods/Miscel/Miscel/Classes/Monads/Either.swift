//
//  Either.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 31/5/16.
//
//

import Foundation

public enum Either<T, ErrorT> {
	case left(ErrorT)
	case right(T)
	
	public init(maybe: T?, error: ErrorT) {
		if let value = maybe {
			self = .right(value)
		}
		else {
			self = .left(error)
		}
	}
}

// MARK: Monad
extension Either {
	public func map<U>(_ f:(T)->(U)) -> Either<U, ErrorT> {
		switch self {
			case .left(let error):
				return Either<U, ErrorT>.left(error)
			
			case .right(let value):
				return Either<U, ErrorT>.right(f(value))
		}
	}
	
	public func mapError<ErrorU>(_ f:(ErrorT)->(ErrorU)) -> Either<T, ErrorU> {
		switch self {
			case .left(let error):
				return Either<T, ErrorU>.left(f(error))
			
			case .right(let value):
				return Either<T, ErrorU>.right(value)
		}
	}
	
	public func flatMap<U>(_ f:(T)->(Either<U, ErrorT>)) -> Either<U, ErrorT> {
		switch self {
			case .left(let error):
				return Either<U, ErrorT>.left(error)
			
			case .right(let value):
				return f(value)
		}
	}
}

