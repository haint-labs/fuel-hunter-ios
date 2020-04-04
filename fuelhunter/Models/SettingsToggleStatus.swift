//
//  SettingsToggleStatus.swift
//  fuelhunter
//
//  Created by Guntis on 12/07/2019.
//  Copyright © 2019 . All rights reserved.
//


enum SettingsToggleResult<Value> {
	case success(Value)
	case needsSetUp
	case failure(String)
}

enum LocationToggleResult<Value> {
	case firstTime
	case secondTime
}
