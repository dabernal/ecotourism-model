Class {
	#name : 'BaselineOfEcotourism',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfEcotourism',
	#package : 'BaselineOfEcotourism'
}

{ #category : 'as yet unclassified' }
BaselineOfEcotourism >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec
			package: 'Ecotourism-Model';
		
			package: 'Ecotourism-Model-Tests'
			with: [ spec requires: #('Ecotourism-Model') ] ].
]
