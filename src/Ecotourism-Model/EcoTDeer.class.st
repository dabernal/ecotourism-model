Class {
	#name : 'EcoTDeer',
	#superclass : 'CMAgent',
	#instVars : [
		'meal_size',
		'energy_loss_time',
		'energy_loss_reproduction',
		'energy_loss_flee',
		'energy_loss_movement',
		'reproduction_prob',
		'hunger_threshold',
		'energy'
	],
	#category : 'Ecotourism-Model',
	#package : 'Ecotourism-Model'
}

{ #category : 'as yet unclassified' }
EcoTDeer >> bestNeighbour [
" Return the cell with more grassA"

	^ (self plotsWithEnoughFood sorted: [ :a :b | a grassA > b grassA ]) first
]

{ #category : 'as yet unclassified' }
EcoTDeer >> eat [

	self cell biomass > meal_size 
		ifFalse: [self eatEverything ]
		ifTrue: [ self eatTheMeal ]
]

{ #category : 'as yet unclassified' }
EcoTDeer >> eatEverything [

	energy := energy + (self cell biomass).
	self cell grassA: 0.
	self cell grassB: 0.
	self cell biomass: 0
]

{ #category : 'as yet unclassified' }
EcoTDeer >> eatTheMeal [

	| half_meal missing |
	
	half_meal := meal_size / 2.
	energy := energy + meal_size.

	self cell grassA >= half_meal
		ifTrue: [ self cell grassA: self cell grassA - half_meal ]
		ifFalse: [
				missing := half_meal - self cell grassA.
				self cell grassA: 0.
				self cell grassB: self cell grassB - missing ].

	self cell grassB >= half_meal
		ifTrue: [ self cell grassB: self cell grassB - half_meal ]
		ifFalse: [
				missing := half_meal - self cell grassB.
				self cell grassB: 0.
				self cell grassA: self cell grassA - missing ]
]

{ #category : 'accessing' }
EcoTDeer >> energy [

	^ energy
]

{ #category : 'accessing' }
EcoTDeer >> energy: anObject [

	energy := anObject
]

{ #category : 'accessing' }
EcoTDeer >> energy_loss_flee [

	^ energy_loss_flee
]

{ #category : 'accessing' }
EcoTDeer >> energy_loss_flee: anObject [

	energy_loss_flee := anObject
]

{ #category : 'accessing' }
EcoTDeer >> energy_loss_movement [

	^ energy_loss_movement
]

{ #category : 'accessing' }
EcoTDeer >> energy_loss_movement: anObject [

	energy_loss_movement := anObject
]

{ #category : 'accessing' }
EcoTDeer >> energy_loss_reproduction [

	^ energy_loss_reproduction
]

{ #category : 'accessing' }
EcoTDeer >> energy_loss_reproduction: anObject [

	energy_loss_reproduction := anObject
]

{ #category : 'accessing' }
EcoTDeer >> energy_loss_time [

	^ energy_loss_time
]

{ #category : 'accessing' }
EcoTDeer >> energy_loss_time: anObject [

	energy_loss_time := anObject
]

{ #category : 'as yet unclassified' }
EcoTDeer >> flee [

	self freeNeighbours isNotEmpty ifTrue: [  
		self moveTo:  (self selectRandomlyFrom: self freeNeighbours )
			
	].
	energy := energy - energy_loss_flee 
	
]

{ #category : 'as yet unclassified' }
EcoTDeer >> freeNeighbours [
" all neighbouring cells without Deer"

	^self cell neighbourhood select: [ :c | c hasNoOccupants ]  
		 
]

{ #category : 'accessing' }
EcoTDeer >> hunger_threshold [

	^ hunger_threshold
]

{ #category : 'accessing' }
EcoTDeer >> hunger_threshold: anObject [

	hunger_threshold := anObject
]

{ #category : 'as yet unclassified' }
EcoTDeer >> initialize [ 
	super initialize .
	energy := 0.5.
	meal_size := 0.9.
	energy_loss_time := 0.01.
	energy_loss_reproduction := 0.5.
	energy_loss_movement := 0.1.
	energy_loss_flee := 2.5*energy_loss_movement .
	reproduction_prob := 0.01.
	hunger_threshold := 0.6.
	
	
]

{ #category : 'accessing' }
EcoTDeer >> meal_size [

	^ meal_size
]

{ #category : 'accessing' }
EcoTDeer >> meal_size: anObject [

	meal_size := anObject
]

{ #category : 'as yet unclassified' }
EcoTDeer >> move [

	self freeNeighbours isNotEmpty ifTrue: [  
		self plotsWithEnoughFood isNotEmpty 
			ifFalse: [self moveTo:  (self selectRandomlyFrom: self freeNeighbours )]
			ifTrue: [self moveTo:  self bestNeighbour ]
	].
	energy := energy - energy_loss_movement 
	
]

{ #category : 'as yet unclassified' }
EcoTDeer >> plotsWithEnoughFood [
|threshhold|

	threshhold := energy_loss_time + energy_loss_movement .
	^self freeNeighbours select: [ :c | c biomass > threshhold  ]
]

{ #category : 'as yet unclassified' }
EcoTDeer >> pov [ 
<pov>
	^ CMPointOfView color: CMColor blue size: 0.6
		 
]

{ #category : 'as yet unclassified' }
EcoTDeer >> reproduce [
" create a new deer"
	(self freeNeighbours isNotEmpty) 
		ifTrue: [ 
			self cormasModel newEntity: EcoTDeer locatedAt: (self selectRandomlyFrom: self freeNeighbours).
			energy:= energy - energy_loss_reproduction ]
]

{ #category : 'accessing' }
EcoTDeer >> reproduction_prob [

	^ reproduction_prob
]

{ #category : 'accessing' }
EcoTDeer >> reproduction_prob: anObject [

	reproduction_prob := anObject
]

{ #category : 'as yet unclassified' }
EcoTDeer >> step [ 

	self touristAround isNotEmpty ifTrue: [self flee ]
	ifFalse: [  
	(energy < hunger_threshold) 
		ifTrue: [self eat]
		ifFalse: [(self random < reproduction_prob ) ifTrue: [self reproduce] ].
	self move.].
	(energy < 0.0)
		ifTrue: [self die]. 
]

{ #category : 'as yet unclassified' }
EcoTDeer >> touristAround [
"returns cells with tourists"

^self cell neighbourhood select: [ :c | c hasOccupantsOfClass: EcoTTourist ] 
]
