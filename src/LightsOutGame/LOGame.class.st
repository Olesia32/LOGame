Class {
	#name : 'LOGame',
	#superclass : 'BorderedMorph',
	#instVars : [
		'cells',
		'moves',
		'background',
		'titleLabel',
		'movesCountLabel',
		'openCellsLabel',
		'closeCellsLabel',
		'timerLabel',
		'timer',
		'time',
		'theme'
	],
	#classInstVars : [
		'TheGame'
	],
	#category : 'LightsOutGame',
	#package : 'LightsOutGame'
}

{ #category : 'as yet unclassified' }
LOGame class >> changeTheme: aTheme [
TheGame ifNotNil: [ 
	TheGame changeTheme: aTheme ]
]

{ #category : 'initialize-release' }
LOGame class >> close [
   TheGame stopTimer.
	TheGame delete.
	TheGame := nil
]

{ #category : 'world menu' }
LOGame class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #LOGame)
		order: 5;
		with: [
			(aBuilder item: #'Запустити гру')
				order: 0;
				action: [ self open ].
			(aBuilder item: #'Закрити гру')
				order: 3;
				action: [ self close ].
			(aBuilder item: #'Скинути гру')
				order: 1;
				action: [ TheGame resetGame ].
				(aBuilder item: #'Змінити тему')
					order: 2;
					with: [
						(aBuilder item: #'Світла тема') action: [
								self changeTheme: LOTheme new lightTheme ].
						(aBuilder item: #'Темна тема') action: [
								self changeTheme: LOTheme new darkTheme ] ] ].
]

{ #category : 'instance creation' }
LOGame class >> open [

	TheGame ifNil: [
		TheGame := self new.
		TheGame openInWorld]
]

{ #category : 'as yet unclassified' }
LOGame >> cellsPerSide [
"The number of cells along each side of the game"
^10
]

{ #category : 'as yet unclassified' }
LOGame >> changeTheme: aTheme [

	background color: aTheme backgroundColor.
	background borderColor: aTheme textColor.
	titleLabel color: aTheme textColor.
	timerLabel color: aTheme textColor.
	movesCountLabel color: aTheme textColor.
	openCellsLabel color: aTheme textColor.
	closeCellsLabel color: aTheme textColor
]

{ #category : 'as yet unclassified' }
LOGame >> countCloseCells [

	^ cells count: [ :cell | cell isClose ]
]

{ #category : 'as yet unclassified' }
LOGame >> countOpenCells [

	^ cells count: [ :cell | cell isClose not ]
]

{ #category : 'as yet unclassified' }
LOGame >> endGame [
	"Якщо час вийшов, завершуємо гру"

	self inform: 'Час вийшов! Гра завершена.'.
	self class close.
]

{ #category : 'initialization' }
LOGame >> initialize [

	| sampleCell width height n infoPanelX infoPanelY |
	super initialize.
	n := self cellsPerSide.
	moves := 0.
	sampleCell := LOCell new.
	width := sampleCell width.
	height := sampleCell height.
	theme := LOTheme new lightTheme.

	"Додаємо фон"
	background := Morph new color: Color white.
	background bounds:
		(-20 @ -70 extent: width * n + 200 @ (height * n + 150)).
	background borderWidth: 1.
	background borderColor: Color black.
	self addMorph: background behind: self.

	"Встановлюємо розмір ігрового поля"
	self bounds: (50 @ 100 extent: width * n @ 200).
	cells := Array2D new: n tabulate: [ :i :j | self newCellAt: i at: j ].

	"Додаємо заголовок"
	titleLabel := StringMorph new contents: 'LightsOut'.
	titleLabel position: width * n + 200 / 2 @ 60.
	self addMorph: titleLabel.

	"Визначаємо координати для панелі інформації"
	infoPanelX := width * n + 70.
	infoPanelY := 120.

	time := 0.
	timerLabel := StringMorph new contents:
		              'Час: ' , time asString , ' с'.
	timerLabel position: infoPanelX @ infoPanelY.
	self addMorph: timerLabel.
	self startTimer.

	"Відкриті клітинки"
	openCellsLabel := StringMorph new contents:
		                  'Відкритих клітинок: '
		                  , self countOpenCells asString.
	openCellsLabel position: infoPanelX @ (infoPanelY + 60).
	self addMorph: openCellsLabel.

	"Закриті клітинки"
	closeCellsLabel := StringMorph new contents:
		                   'Закритих клітинок: '
		                   , self countCloseCells asString.
	closeCellsLabel position: infoPanelX @ (infoPanelY + 90).
	self addMorph: closeCellsLabel.

	"Кількість ходів"
	movesCountLabel := StringMorph new contents:
		                   'Кількість ходів: ' , self moves asString.
	movesCountLabel position: infoPanelX @ (infoPanelY + 30).
	self addMorph: movesCountLabel
]

{ #category : 'accessing' }
LOGame >> moves [ 
^ moves 
]

{ #category : 'accessing' }
LOGame >> moves: aValue [
moves := aValue 
]

{ #category : 'accessing' }
LOGame >> newCellAt: i at: j [
"Create a cell for position (i,j) and add it to my on?screen
representation at the appropriate screen position. Answer the new cell"
| c origin |
c := LOCell new.
origin := self innerBounds origin.
self addMorph: c.
c position: ((i - 1) * c width) @ ((j - 1) * c height) + origin.
c mouseAction: [self toggleNeighboursOfCellAt: i at: j].
^c
]

{ #category : 'initialization' }
LOGame >> resetGame [
	"Скидає гру до початкових значень"

	moves := 0.
	time := 0.
	timerLabel contents: 'Час: 0 сек'.
	timerLabel changed.
	cells do: [ :cell | cell turnOff ].
	self updateInfoLabels.
]

{ #category : 'as yet unclassified' }
LOGame >> startTimer [
    "Запускаємо таймер, що підраховує час гри"
    timer := [
        [ true ] whileTrue: [ 
            (Delay forSeconds: 1) wait. 
            time := time + 1. 
            self updateTimerDisplay. 
        ].
    ] fork.

]

{ #category : 'as yet unclassified' }
LOGame >> stopTimer [
timer ifNotNil: [timer terminate].
]

{ #category : 'accessing' }
LOGame >> toggleNeighboursOfCellAt: i at: j [

	i > 1 ifTrue: [ (cells at: i - 1 at: j) toggleState ].
	i < self cellsPerSide ifTrue: [ (cells at: i + 1 at: j) toggleState ].
	j > 1 ifTrue: [ (cells at: i at: j - 1) toggleState ].
	j < self cellsPerSide ifTrue: [ (cells at: i at: j + 1) toggleState ].
	moves := moves + 1.
	self updateInfoLabels.
]

{ #category : 'as yet unclassified' }
LOGame >> updateInfoLabels [
    "Оновлюємо інформаційні мітки"
    movesCountLabel contents: 'Кількість ходів: ', self moves asString.
    openCellsLabel contents: 'Відкритих клітинок: ', self countOpenCells asString.
    closeCellsLabel contents: 'Закритих клітинок: ', self countCloseCells asString.
]

{ #category : 'as yet unclassified' }
LOGame >> updateTimerDisplay [

	timerLabel contents: 'Час: ' , time asString , ' с'.
	timerLabel changed
]
