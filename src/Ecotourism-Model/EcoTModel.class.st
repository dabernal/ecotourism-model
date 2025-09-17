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
	^ self cells sum: [ :c | c biomass ]
]

{ #category : 'probes' }
EcoTModel >> grassASize [

	<probeNamed: 'grass A size' color: '19DE0E'>
	^ self cells sum: [ :c | c grassA ]
]

{ #category : 'probes' }
EcoTModel >> grassBsize [

	<probeNamed: 'grass B size' color: 'C0392B'>
	^ self cells sum: [ :c | c grassB ]
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
	^ (self @@ EcoTDeer) size * 10
]

{ #category : 'as yet unclassified' }
EcoTModel >> step [
	"This method will be executed at every step of the simulation"

	<control>
	self cells do: #calculateGrowth .
	(self cells select: [:c | c hasNoOccupants ] ) do: #growth.
	(self allTheEntities: EcoTDeer) do: #step. 
	(self allTheEntities: EcoTTourist ) do: #step 
]
