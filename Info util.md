'Resources': Son elementos utiles que puede ser usados como variable3s globales para los nodos. 





Para eliminar el smoothnes de los pixeles (para hacer que pixel art se vea bien):



&#x09;- project -> Project settings -> Rendering -> textures -> cambiar linear a Nearest











Para hacer que la bala funcione la logica es:



Creo una senal desde el script del jugador: 

&#x09;

&#x09;if Input.is\_action\_just\_pressed("shoot") and not $Timer/ReloadTimer.time\_left:

&#x09;	**shoot.emit(position, get\_local\_mouse\_position().normalized())**

&#x09;	$Timer/ReloadTimer.start()



En el big parent, del level donde los level child se hacen existir. agarro la senal:



&#x09;**func \_on\_player\_shoot(pos: Vector2, dir: Vector2) -> void:**

&#x09;	#This transform the scene into a instance (instance is the unique bullet, no the 'mother bullet'

&#x09;	var bullet = bullet\_scene.instantiate()

&#x09;	

Hago que la instancia general de las ballas, agarre la balla especifica (que es un child)



&#x09;	$Bullets.add\_child(bullet)



En el script de la bala specifica, creo un function (secccion despues del .) con el setup





&#x09;**func setup(pos: Vector2, dir: Vector2):**

&#x09;	position = pos

&#x09;	direction = dir



Ahora en el level parent leo esa function que cree



&#x09;**bullet.setup(pos, dir)**



Donde pos, y dir estan defininidas en la senal inicial **shoot.emit(position, get\_local\_mouse\_position().normalized())**





