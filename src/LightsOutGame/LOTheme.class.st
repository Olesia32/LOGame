Class {
	#name : 'LOTheme',
	#superclass : 'Object',
	#instVars : [
		'backgroundColor',
		'textColor'
	],
	#category : 'LightsOutGame',
	#package : 'LightsOutGame'
}

{ #category : 'accessing' }
LOTheme >> backgroundColor [

	^ backgroundColor
]

{ #category : 'accessing' }
LOTheme >> backgroundColor: anObject [

	backgroundColor := anObject
]

{ #category : 'as yet unclassified' }
LOTheme >> darkTheme [

	self backgroundColor: Color darkGray.
	self textColor: Color white.
	^ self
]

{ #category : 'as yet unclassified' }
LOTheme >> lightTheme [

	self backgroundColor: Color white.
	self textColor: Color black.
	^ self
]

{ #category : 'accessing' }
LOTheme >> textColor [

	^ textColor
]

{ #category : 'accessing' }
LOTheme >> textColor: anObject [

	textColor := anObject
]
