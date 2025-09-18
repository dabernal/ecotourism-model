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

{ #category : 'as yet unclassified' }
EcoTDeer >> flee [

	self freeNeighbours ifNotEmpty: [  
		self moveTo:  (self selectRandomlyFrom: self freeNeighbours ).
		energy := energy - energy_loss_flee
			
	].
	 
	
]

{ #category : 'as yet unclassified' }
EcoTDeer >> freeNeighbours [
" all neighbouring cells without Deer"

	^self cell neighbourhood select: [ :c | c hasNoOccupants ]  
		 
]

{ #category : 'as yet unclassified' }
EcoTDeer >> initialize [ 
	super initialize .
	energy := 0.5.
	meal_size := 0.9.
	energy_loss_time := 0.01.
	energy_loss_reproduction := 0.4.
	energy_loss_movement := 0.1.
	energy_loss_flee := 2.5*energy_loss_movement .
	reproduction_prob := 0.01.
	hunger_threshold := 0.6.
	
	
]

{ #category : 'as yet unclassified' }
EcoTDeer >> move [
	" The deer moves if there is an empty plot around and if there is enough food to the one with more grassA"
	| freeNeighbours plotsWithEnoughFood bestNeighbour |
	
	freeNeighbours := self freeNeighbours.
	freeNeighbours ifEmpty: [ ^ self ].
	
	plotsWithEnoughFood := freeNeighbours select: [ :c |
		c biomass > (energy_loss_time + energy_loss_movement) ].
	
	bestNeighbour := plotsWithEnoughFood 
		ifEmpty: [ self selectRandomlyFrom: freeNeighbours ]
		ifNotEmpty: [ (plotsWithEnoughFood sorted: [ :a :b | a grassA > b grassA ]) first].
	
	self moveTo: bestNeighbour.
	energy := energy - energy_loss_movement.
	
	
]

{ #category : 'as yet unclassified' }
EcoTDeer >> pov [ 
<pov>
	^ CMPointOfView color: CMColor blue size: 0.6
		 
]

{ #category : 'as yet unclassified' }
EcoTDeer >> reproduce [
" create a new deer"
	self freeNeighbours ifNotEmpty:[ 
		self cormasModel newEntity: EcoTDeer locatedAt: (self selectRandomlyFrom: self freeNeighbours).
		energy:= energy - energy_loss_reproduction ]
]

{ #category : 'as yet unclassified' }
EcoTDeer >> step [ 

	(self touristAround isNotEmpty) 
		ifTrue: [self flee ]
		ifFalse: [  
			(energy < hunger_threshold) 
				ifTrue: [ self eat ]
				ifFalse: [(self random < reproduction_prob ) ifTrue: [self reproduce. self eat] ].
			self move
		].
	
	energy := energy - energy_loss_time .
	
	(energy < 0.0)
		ifTrue: [self die]. 
]

{ #category : 'as yet unclassified' }
EcoTDeer >> touristAround [
"returns cells with tourists"

^self cell neighbourhood select: [ :c | c hasOccupantsOfClass: EcoTTourist ] 
]
