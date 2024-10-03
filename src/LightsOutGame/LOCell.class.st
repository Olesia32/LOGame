Class {
	#name : 'LOCell',
	#superclass : 'SimpleSwitchMorph',
	#instVars : [
		'mouseAction'
	],
	#category : 'LightsOutGame',
	#package : 'LightsOutGame'
}

{ #category : 'initialization' }
LOCell >> initialize [

	super initialize.
	self label: ''.
	self borderWidth: 2.
	bounds := 0 @ 0 corner: 16 @ 16.
	offColor := Color yellow .
	onColor := Color blue darker.
	self useSquareCorners.
	self turnOff
]

{ #category : 'accessing' }
LOCell >> isClose [

	^ self isOn
]

{ #category : 'accessing' }
LOCell >> mouseAction: aBlock [
^ mouseAction := aBlock.
]

{ #category : 'event handling' }
LOCell >> mouseUp: anEvent [
mouseAction value.
]
