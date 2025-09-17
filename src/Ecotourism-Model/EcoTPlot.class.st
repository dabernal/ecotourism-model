Class {
	#name : 'EcoTPlot',
	#superclass : 'CMCell',
	#instVars : [
		'grassA',
		'grassB',
		'bufferA',
		'bufferB',
		'biomass',
		'occupied',
		'rCoef',
		'difRate'
	],
	#category : 'Ecotourism-Model',
	#package : 'Ecotourism-Model'
}

{ #category : 'accessing' }
EcoTPlot >> biomass [

	^ biomass
]

{ #category : 'accessing' }
EcoTPlot >> biomass: anObject [

	biomass := anObject
]

{ #category : 'accessing' }
EcoTPlot >> bufferA [

	^ bufferA
]

{ #category : 'accessing' }
EcoTPlot >> bufferA: anObject [

	bufferA := anObject
]

{ #category : 'accessing' }
EcoTPlot >> bufferB [

	^ bufferB
]

{ #category : 'accessing' }
EcoTPlot >> bufferB: anObject [

	bufferB := anObject
]

{ #category : 'initialization' }
EcoTPlot >> calculateGrowth [

	| neighboursGrassA neighboursGrassB changeGrassA changeGrassB |

	neighboursGrassA := self neighbourhood sum: [ :c | c grassA ].

	neighboursGrassB := self neighbourhood sum: [ :c | c grassB ].


	changeGrassA := rCoef
	                *
	                ((1 - difRate) * grassA + (difRate * neighboursGrassA))
	                * (1 - biomass).

	bufferA := 0 max: (grassA + changeGrassA).

	changeGrassB := rCoef
	                *
	                ((1 - difRate) * grassB + (difRate * neighboursGrassB))
	                * (1 - biomass).

	bufferB := 0 max: (grassB + changeGrassB)


	"changeBiomass := rCoef * biomass * (1 - biomass)."
	"grassA := grassA * (1 + (changeBiomass / biomass)).

	grassB := grassB * (1 + (changeBiomass / biomass))."
]

{ #category : 'accessing' }
EcoTPlot >> difRate [

	^ difRate
]

{ #category : 'accessing' }
EcoTPlot >> difRate: anObject [

	difRate := anObject
]

{ #category : 'accessing' }
EcoTPlot >> grassA [

	^ grassA
]

{ #category : 'accessing' }
EcoTPlot >> grassA: anObject [

	grassA := anObject
]

{ #category : 'accessing' }
EcoTPlot >> grassB [

	^ grassB
]

{ #category : 'accessing' }
EcoTPlot >> grassB: anObject [

	grassB := anObject
]

{ #category : 'initialization' }
EcoTPlot >> growth [

	grassA:= bufferA.

	grassB:= bufferB.
	
	biomass:= grassA + grassB 
]

{ #category : 'initialization' }
EcoTPlot >> initialize [

	|  percentageA |
	super initialize.
	biomass:= self random.
	percentageA := self random.
	grassA := biomass * percentageA.
	grassB := biomass * (1 - percentageA).
	
	rCoef := 0.1.
	difRate := 0.02.
	
]

{ #category : 'initialization' }
EcoTPlot >> pov [

	<pov>
	^ CMPointOfView color:
		  (Color r: grassA g: 0 b: 0) + (Color r: 0 g: grassB b: 0)
	
]

{ #category : 'initialization' }
EcoTPlot >> povGrassA [

	<pov>
	^ CMPointOfView color:
		  (Color r: grassA g: 0 b: 0)
	
]

{ #category : 'initialization' }
EcoTPlot >> povGrassB [

	<pov>
	^ CMPointOfView color:
		  (Color r: 0 g: grassB b: 0)
	
]

{ #category : 'accessing' }
EcoTPlot >> rCoef [

	^ rCoef
]

{ #category : 'accessing' }
EcoTPlot >> rCoef: anObject [

	rCoef := anObject
]
