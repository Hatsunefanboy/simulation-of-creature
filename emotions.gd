class_name Emotion
var joie : float 
var tristesse : float
var colere : float
var peur : float

func _init(j=0,t=0,c=0,p=0):
	joie = j
	tristesse =t
	colere = c
	peur = p
func norme():
	return (joie**2+colere**2+tristesse**2+peur**2)**(1/2)

func mult(l):
	joie *= l
	colere*= l
	tristesse*= l
	peur  *= l
	return self
func add(other):
	joie += other.joie
	tristesse += other.tristesse
	colere += other.colere
	peur += other.peur 
	return self
func copie():
	return Emotion.new(joie,tristesse,colere,peur)

func distance(other):
	return copie().add(other.copie().mult(-1)).norme()
