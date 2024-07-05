extends CanvasLayer

# Declare viewport references
@export var viewport1: Viewport
@export var viewport2: Viewport

# Declare textures to store the viewport textures
var texture1: Texture2D
var texture2: Texture2D

# Declare a new viewport texture to combine the results
var combined_texture: ImageTexture

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the textures from the viewports
	texture1 = viewport1.get_texture()
	texture2 = viewport2.get_texture()

	# Create a new ImageTexture for combining the results
	combined_texture = ImageTexture.new()
	combined_texture.create(viewport1.size.x, viewport1.size.y)

	# Create a shader material to combine the textures
	var shader_material = ShaderMaterial.new()
	shader_material.shader = Shader.new()
	shader_material.shader.code = """
		shader_type canvas_item;

		uniform sampler2D texture1;
		uniform sampler2D texture2;

		void fragment() {
			vec4 color1 = texture(texture1, FRAGCOORD.xy / SCREEN_PIXEL_SIZE);
			vec4 color2 = texture(texture2, FRAGCOORD.xy / SCREEN_PIXEL_SIZE);
			COLOR = mix(color1, color2, 0.5);
		}
	"""

	shader_material.set_shader_parameter("texture1", texture1)
	shader_material.set_shader_parameter("texture2", texture2)

	# Create a TextureRect to display the combined texture
	var texture_rect = TextureRect.new()
	texture_rect.texture = combined_texture
	texture_rect.material = shader_material
	texture_rect.size = viewport1.size
	texture_rect.set_stretch_mode(TextureRect.STRETCH_SCALE)

	# Add the TextureRect to the CanvasLayer
	add_child(texture_rect)

# Update the combined texture every frame
func _process(delta):
	if texture1.is_valid() and texture2.is_valid():
		combined_texture.set_data(texture1.get_data())
		combined_texture.get_data().blend_rect(texture2.get_data(), Rect2(Vector2(0, 0), viewport2.size), Vector2(0, 0))
