Class {
	#name : 'EcoTModel',
	#superclass : 'CMAbstractModel',
	#classInstVars : [
		'numberOfTourists'
	],
	#category : 'Ecotourism-Model',
	#package : 'Ecotourism-Model'
}

{ #category : 'initialization' }
EcoTModel class >> initializeParameters [

	super initializeParameters.
	numberOfTourists := 20
]

{ #category : 'accessing' }
EcoTModel class >> numberOfTourists [

	^ numberOfTourists
]

{ #category : 'accessing' }
EcoTModel class >> numberOfTourists: anObject [

	numberOfTourists := anObject
]

{ #category : 'probes' }
EcoTModel >> biomassSize [

	<probeNamed: 'biomass size' color: '0E0EDE'>
	^ (self cells collect: [ :c | c biomass ]) average
]

{ #category : 'probes' }
EcoTModel >> deerTouristEncounters [

	<probeNamed: 'Deer encounters' color: '19DE0E'>
	^ ((self @@ EcoTTourist  ) sum: [ :c | c deersHumanEncounters ]) / 20
]

{ #category : 'probes' }
EcoTModel >> grassASize [

	<probeNamed: 'grass A size' color: 'C0392B'>
	^ (self cells collect: [ :c | c grassA ]) average
]

{ #category : 'probes' }
EcoTModel >> grassBsize [

	<probeNamed: 'grass B size' color: '19DE0E'>
	^ (self cells collect: [ :c | c grassB ]) average
]

{ #category : 'as yet unclassified' }
EcoTModel >> init [
	<init>
	self
		createGridNumberOfRows: 30
		numberOfColumns: 30
		neighbourhood: 4
		closed: true.


	self createN: 20 randomlyLocatedAloneEntities: EcoTDeer .
	self createN: self class numberOfTourists randomlyLocatedAloneEntities: EcoTTourist .
]

{ #category : 'as yet unclassified' }
EcoTModel >> modelName [
	"A human-friendly name of the model"
	^ 'Ecotourism'
]

{ #category : 'probes' }
EcoTModel >> numberOfDeers [

	<probeNamed: 'deers' color: 'F39C12'>
	^ ((self @@ EcoTDeer) size) / 25
]

{ #category : 'probes' }
EcoTModel >> numberOfTourists [

	<probeNamed: 'tourists' color: '161617'>
	^ ((self @@ EcoTTourist ) size) /20
]

{ #category : 'probes' }
EcoTModel >> percentageGrassB80 [

	<probeNamed: 'biomass>80 size' color: '0E0EDE'>
	^ (self cells select: [ :c | c grassB > 0.8 ]) size / 900
]

{ #category : 'export' }
EcoTModel >> saveDataToFile: aFileReference [ 

	| data columnNames |
	data := self data.

	data ifNil: [ ^ self ].
	data ifEmpty: [ ^ self ].
	aFileReference ifNil: [ ^ self ].
	
	aFileReference writeStreamDo: [ :stream |
		columnNames := data first keys.
		stream nextPutAll: (',' join: columnNames); cr.
		
		data do: [ :row |
			stream nextPutAll: (',' join: row); cr ] ].


]

{ #category : 'controlling' }
EcoTModel >> step [
	"This method will be executed at every step of the simulation"

	<control>
	self cells do: #calculateGrowth .
	(self cells select: [:c | c hasNoOccupants ] ) do: #growth.
	(self allTheEntities: EcoTDeer) do: #step. 
	(self allTheEntities: EcoTTourist ) do: #step .
	
]

{ #category : 'controlling' }
EcoTModel >> step: t [
	"This method will be executed at every step of the simulation"

	<control>
	self cells do: #calculateGrowth .
	(self cells select: [:c | c hasNoOccupants ] ) do: #growth.
	(self allTheEntities: EcoTDeer) do: #step. 
	(self allTheEntities: EcoTTourist ) do: #step .
	t = 2500 ifTrue: [ self saveDataToFile: ('file_tourist_', self class numberOfTourists asString, '.csv') asFileReference ]
	
]
