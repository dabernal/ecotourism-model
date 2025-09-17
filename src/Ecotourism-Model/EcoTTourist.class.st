Class {
	#name : 'EcoTTourist',
	#superclass : 'CMAgent',
	#instVars : [
		'degradation_visitor'
	],
	#category : 'Ecotourism-Model',
	#package : 'Ecotourism-Model'
}

{ #category : 'accessing' }
EcoTTourist >> degradeGrass [

	self cell grassA: (self cell grassA) * (1-degradation_visitor).
	self cell grassB: (self cell grassB) * (1-degradation_visitor).
	self cell biomass: (self cell grassB) +(self cell grassA)
]

{ #category : 'accessing' }
EcoTTourist >> freeNeighbours [
" all neighbouring cells without Deer"

	^self cell neighbourhood select: [ :c | c hasNoOccupants ]  
]

{ #category : 'initialization' }
EcoTTourist >> initialize [ 
 	super initialize .
	degradation_visitor := 0.1
]

{ #category : 'accessing' }
EcoTTourist >> move [
	| freeNeighbours |
	self neighbourPlotWithDeer ifEmpty: [
		freeNeighbours := self freeNeighbours.
		
		freeNeighbours ifNotEmpty: [
			self moveTo: (self selectRandomlyFrom: freeNeighbours) ] ]
]

{ #category : 'accessing' }
EcoTTourist >> neighbourPlotWithDeer [
" returns plots with neighbouring Deers"

	^self cell neighbourhood select: [ :c | c hasOccupantsOfClass: EcoTDeer ]
]

{ #category : 'accessing' }
EcoTTourist >> pov [
<pov>
	^ CMPointOfView color: CMColor red size: 0.6 
]

{ #category : 'accessing' }
EcoTTourist >> step [

	self move.
	self degradeGrass 
]
