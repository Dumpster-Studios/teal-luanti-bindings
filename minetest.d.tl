global dump : function(obj: any, indent : number | nil): string

global dump2: function(obj: any): string

global record RGBA
  r: number
  g: number
  b: number
  a: number | nil
end

global type ColorSpec =  number | string | RGBA

global record Vector2D
  x: number
  y: number
end

global record Vector3D
  x: number
  y: number
  z: number
end

global record Node
  name: string
  param1: number
  param2: number
end

local enum PointedTypes
  "nothing"
  "node"
  "object"
end

global record PointedNode
  type: PointedTypes -- should be constant "node"
  under: Vector3D
  above: Vector3D
end

global record PointedObject
  type: PointedTypes -- should be constant "object"
  ref: ObjectRef
end

global record PointedNothing
  type: PointedTypes -- should be constant "nothing"
end

-- technically PointedThing is a union of PointedNode | PointedObject | PointedNothing
global record PointedThing
  type: PointedTypes
  under: Vector3D | nil
  above: Vector3D | nil
  ref: ObjectRef | nil
end

-- technically Item is a union of ItemStack | ItemTable | string
global type Item = any | string

global enum EmergeAreaAction
  "EMERGE_CANCELLED"
  "EMERGE_ERRORED"
  "EMERGE_FROM_MEMORY"
  "EMERGE_FROM_DISK"
  "EMERGE_GENERATED"
end


global record minetest
  CONTENT_UNKNOWN: number
  CONTENT_AIR: number
  CONTENT_IGNORE: number
  EMERGE_CANCELLED: EmergeAreaAction
  EMERGE_ERRORED: EmergeAreaAction
  EMERGE_FROM_MEMORY: EmergeAreaAction
  EMERGE_FROM_DISK: EmergeAreaAction
  EMERGE_GENERATED: EmergeAreaAction

  registered_items: {string: ItemDefinition}
end

global record MetaDataRef
  contains: function(string): boolean | nil
  get: function(string): string | nil
  set_string: function(string, string): string
  get_string: function(string): string
  set_int: function(string, number): nil
  get_int: function(string): number
  set_float: function(string, number): nil
  get_float: function(string): number
end

global record ItemDefinition
  name: string
  description: string | nil
  short_description: string | nil
  wield_image: string | nil
  inventory_image: string | {string, string, string} | nil
  groups: {string: number} | nil
  tool_capabilities: any | nil
  range: number | nil
  node_placement_prediction: string | nil
  on_place: nil | function(
    itemstack: ItemStack,
    placer: ObjectRef | nil,
    pointed_thing: PointedNode
  ) : (ItemStack | nil)
  on_use: nil | function(
    itemstack: ItemStack,
    user: ObjectRef | nil,
    pointed_thing: PointedThing
  ) : (ItemStack | nil)
  after_use: nil | function(
    itemstack: ItemStack,
    user: ObjectRef | nil,
    node: Node,
    digparams: any
  ): (ItemStack | nil)
  on_drop: nil | function(
    itemstack: ItemStack,
    dropper: ObjectRef | nil,
    pos: Vector3D
  ) : (ItemStack | nil)

end

global record ItemTable
  name: string
  count: number
  wear: number
  metadata: string
end

global record ItemStack
  add_item: function(item: Item): nil
  add_wear: function(amount: number): nil
  clear: function(): nil
  get_count: function(): number
  set_count: function(count: number): boolean
  get_definition: function(): ItemDefinition
  get_free_space: function(): number
  get_meta: function(): MetaDataRef
  get_metadata: function(): string
  get_name: function(): string
  set_name: function(name: string): boolean
  get_stack_max: function(): number
  get_tool_capabilities: function(): any
  get_wear: function(): number
  set_wear: function(wear: number): boolean
  is_empty: function(): boolean
  is_known: function(): boolean
  item_fits: function(item: Item): boolean
  peek_item: function(n: number | nil): ItemStack
  replace: function(item: Item | string): nil
  take_item: function(n: number | nil): ItemStack
  to_string: function(): string
  to_table: function(): any
end

local enum ObjectPropertiesVisual
  "cube"
  "sprite"
  "upright_sprite"
  "mesh"
  "wielditem"
  "item"
end

global record ObjectProperties 
  eye_height: number | nil
  physical: boolean | nil
  collide_with_objects: boolean | nil
  collisionbox: {number, number, number, number, number, number} | nil
  selectionbox: {number, number, number, number, number, number} | nil
  pointable: boolean | nil
  visual: ObjectPropertiesVisual | nil
  visual_size: Vector3D | nil
  mesh: string | nil

  -- technically this should be string | {string} | {string, string} | {string, string, string, string, string, string}
  textures: string | {string} | nil
  use_texture_alpha: boolean | nil
  spritediv: Vector2D | nil
  initial_sprite_basepos: Vector2D | nil
  is_visible: boolean | nil
  makes_footstep_sound: boolean | nil
  automatic_rotate: number | nil
  stepheight: number | nil
  automatic_face_movement_dir: number | nil
  automatic_face_movement_max_rotation_per_sec: number | nil
  backface_culling: boolean | nil
  glow: number | nil
  nametag: string | nil
  nametag_color: ColorSpec | nil
  nametag_bgcolor: ColorSpec | nil
  infotext: string | nil
  static_save: boolean | nil
  damage_texture_modifier: string | nil
  shaded: boolean | nil
  show_on_minimap: boolean | nil
end

global record InvRef 
  is_empty: function(string): boolean
  get_size: function(string): number
  set_size: function(string, number): nil
  get_width: function(string): number
  set_width: function(string, number): nil
  get_stack: function(string, number): ItemStack
  set_stack: function(string, number, Item): nil
  get_list: function(string): {ItemStack}
  set_list: function(string, {Item}): nil
  get_lists: function(): { string: {ItemStack} }
  set_lists: function(lists: { string: {Item} }): nil
  add_item: function(string, stack: Item): ItemStack
  room_for_item: function(string, stack: Item): boolean
  contains_item: function(string, stack: Item): boolean
  remove_item: function(string, stack: Item): ItemStack
end

local record ObjectRefGetAnimation
  frames: Vector2D
  frame_speed: number
  frame_blend: number
  frame_loop: boolean
end

local record ObjectRefGetAttach
  parent: ObjectRef
  bone: string
  position: Vector3D
  rotation: any
end

local record ObjectRefGetNametagAttributes
  text: string
  color: RGBA
  bgcolor: RGBA
end

local record ObjectRefSetNametagAttributesArgs
  text: string
  color: ColorSpec
  bgcolor: ColorSpec | boolean
end

global record ObjectRef
  get_pos: function(): Vector3D
  get_armor_groups: function(): { string: any }
  get_animation: function(): ObjectRefGetAnimation
  get_hp: function(): number
  get_breath: function(): number
  get_inventory: function(): InvRef
  get_wielded_item: function(): ItemStack
  get_wield_index: function(): number
  get_wield_list: function(): string
  move_to: function(pos: Vector3D, continuous: boolean | nil): nil
  punch: function(
    puncher: ObjectRef,
    time_from_last_punch: number,
    direction: Vector3D | nil
  ): nil
  right_click: function(clicker: ObjectRef): nil
  set_pos: function(pos: Vector3D): nil
  set_armor_groups: function(groups: { string: any }): nil
  set_hp: function(hitpoints: number): nil
  set_wielded_item: function(item: Item): boolean
  set_animation: function(
    frame_range: Vector2D,
    frame_speed: number | nil,
    frame_blend: number | nil,
    frame_loop: boolean | nil
  ): nil
  set_attach: function(
    parent: ObjectRef,
    bone: string | nil,
    position: Vector3D | nil,
    rotation: Vector3D | nil
  ): nil
  set_detach: function(): nil
  get_attach: function(): ObjectRefGetAttach
  set_bone_position: function(bone: string | nil, v1: Vector3D | nil, v2: Vector3D | nil): nil
  set_properties: function(ObjectProperties): nil
  get_properties: function(): ObjectProperties
  is_player: function(): boolean
  get_nametag_attributes: function(): ObjectRefGetNametagAttributes
  set_nametag_attributes: function(attributes: ObjectRefSetNametagAttributesArgs)
end
