# godot4_contour_detection trial

This is a Suzuki85 edge detection program code written in GDScript.

The original detection program code ([Rajdeep Mondal](https://github.com/RajdeepMondal)) was written in Python, 
but I rewrote it using GDScript.

# Version
 0.0.5 ( update 2026/01/15 )

# Results-1 (Box)
## original
![demo](https://raw.githubusercontent.com/wiki/amami-harhid/godot_sprite2d_ext/images/contour_detection_sample01.PNG)

## Thresholding
![demo](https://raw.githubusercontent.com/wiki/amami-harhid/godot_sprite2d_ext/images/contour_detection_sample02.PNG)

## Contour tracing
![demo](https://raw.githubusercontent.com/wiki/amami-harhid/godot_sprite2d_ext/images/contour_detection_sample03.PNG)

## Draw points at intervals of 10 ms
![demo](https://raw.githubusercontent.com/wiki/amami-harhid/godot_sprite2d_ext/images/contour_detection_sample03.gif)

# Results-2 (Crab)
## original
![demo](https://raw.githubusercontent.com/wiki/amami-harhid/godot_sprite2d_ext/images/contour_detection_sample04.PNG)

## Thresholding
![demo](https://raw.githubusercontent.com/wiki/amami-harhid/godot_sprite2d_ext/images/contour_detection_sample05.PNG)

## Contour tracing
![demo](https://raw.githubusercontent.com/wiki/amami-harhid/godot_sprite2d_ext/images/contour_detection_sample06.PNG)

## Draw points at intervals of 10 ms
![demo](https://raw.githubusercontent.com/wiki/amami-harhid/godot_sprite2d_ext/images/contour_detection_sample06.gif)


# usage sample

```
	var sprite:Sprite2D = $"../Sprite2D" # sprite original image
	
	# Create new texture( ImageTexture )
	var org_image:Image = sprite.texture.get_image()
	var _texture:ImageTexture = ImageTexture.new()
	var _image:Image = Image.create(
		org_image.get_size().x,
		org_image.get_size().y, 
		false, Image.FORMAT_RGBA8)
	_image.fill(Color(1,1,1,0))
	_texture.set_image(_image)
	self.texture = _texture	

	# Contour Detection
	var _detection:ContourDetection.Detection = ContourDetection.Detection.new()
	self.detection = _detection
	var contour_info:ContourDetection.ContoursInfo = _detection.raster_scan(org_image)
	# Drawing
	for _contour:ContourDetection.Contour in contour_info.sorted_list():
		#print(",nbd=",_contour.get_nbd())
		for cell:ContourDetection.Cell in _contour.list():
			var _pos = cell.to_vector2()
			_image.set_pixel(_pos.x, _pos.y, Color(0,0,0,1))
			_texture.set_image(_image)
			self.texture = _texture


```

# state
The current state is being debugged.

# Reference

## python code ( original )
https://github.com/RajdeepMondal/Contour-Detection/blob/master

## Related Articles
https://theailearner.com/tag/suzuki-contour-algorithm-opencv/
