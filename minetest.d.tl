global dump: function(obj: any, indent : number | nil): string

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

global enum PointedTypes
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
  registered_nodes: {string: ItemDefinition}
end

global record MetaDataRef
  contains: function(key: string): boolean | nil
  get: function(key: string): string | nil
  set_string: function(key: string, value: string): string
  get_string: function(key: string): string
  set_int: function(key: string, value: number): nil
  get_int: function(key: string): number
  set_float: function(key: string, value: number): nil
  get_float: function(key: string): number
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
  collisionbox: {number} | nil
  selectionbox: {number} | nil
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
  is_empty: function(listname: string): boolean
  get_size: function(listname: string): number
  set_size: function(listname: string, size: number): nil
  get_width: function(listname: string): number
  set_width: function(listname: string, width: number): nil
  get_stack: function(listname: string, index: number): ItemStack
  set_stack: function(listname: string, index: number, stack: Item): nil
  get_list: function(listname: string): {ItemStack}
  set_list: function(listname: string, list: {Item}): nil
  get_lists: function(): { string: {ItemStack} }
  set_lists: function(lists: { string: {Item} }): nil
  add_item: function(listname: string, stack: Item): ItemStack
  room_for_item: function(listname: string, stack: Item): boolean
  contains_item: function(listname: string, stack: Item): boolean
  remove_item: function(listname: string, stack: Item): ItemStack
end

global record ObjectRefGetAnimation
  frames: Vector2D
  frame_speed: number
  frame_blend: number
  frame_loop: boolean
end

global record ObjectRefGetAttach
  parent: ObjectRef
  bone: string
  position: Vector3D
  rotation: any
end

global record ObjectRefGetNametagAttributes
  text: string
  color: RGBA
  bgcolor: RGBA
end

global record ObjectRefSetNametagAttributesArgs
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

global enum DrawType
  "normal"
  "airlike"
  "allfaces"
  "allfaces_optional"
  "glasslike"
  "glasslike_framed"
  "glasslike_framed_optional"
  "liquid"
  "flowingliquied"
  "torchlike"
  "signlike"
  "plantlike"
  "raillike"
  "fencelike"
  "firelike"
  "nodebox"
  "mesh"
end

global enum NodeDefinitionUseTextureAlpha
  "opaque"
  "clip"
  "blend"
end

global enum NodeDefinitionParamType
  "none"
  "light"
end

global enum NodeDefinitionParamType2
  "flowingliquid"
  "wallmounted"
  "facedir"
  "4dir"
  "leveled"
  "degrotate"
  "meshoptions"
  "color"
  "colorfacedir"
  "color4dir"
  "colorwallmounted"
  "glasslikeliquidlevel"
  "colordegrotate"
  "none"
end

global enum TileAnimationDefinitionType
  "vertical_frames"
  "sheet_2d"
end

-- suppress pls
global record TileAnimationDefinitionVerticalFrames
  type: TileAnimationDefinitionType -- "vertical_frames"
  aspect_w: number
  aspect_h: number
  length: number
end

-- suppress pls
global record TileAnimationDefinitionSheet2D
  type: TileAnimationDefinitionType -- "sheet_2d"
  frames_w: number
  frames_h: number
  frame_length: number
end

global record TileAnimationDefinitionUnion
  type: TileAnimationDefinitionType
  aspect_w: number
  aspect_h: number
  length: number
  frames_w: number
  frames_h: number
  frame_length: number
end

-- suppress pls
global record TileDefinitionAnimated
  name: string
  animation: {TileAnimationDefinitionUnion}
end

global enum TileDefinitionAlignStyle
  "world"
  "node"
  "user"
end

-- suppress pls
global record TileDefinitionOther
  name: string
  backface_culling: boolean
  align_style: TileDefinitionAlignStyle
  scale: number
end

global record TileDefinitionUnion 
  -- TileDefinitionAnimated
  name: string
  animation: {TileAnimationDefinitionUnion}
  -- TileDefinitionOther
  backface_culling: boolean
  align_style: TileDefinitionAlignStyle
  scale: number
end

global type TileDefinition = string | TileDefinitionUnion

global record DropDefinition
  items: {Item}
  rarity: number
  tools: {string}
end

-- suppress pls
global record NodeDefinitionDrop
  items: {DropDefinition}
  max_items: number
end

global enum NodeDefinitionLiquidType
  "none"
  "source"
  "flowing"
end

global record SimpleSoundSpecRecord
  name: string
  gain: number
  pitch: number
end

global type SimpleSoundSpec = SimpleSoundSpecRecord | string

global record NodeDefinitionSounds
  footstep: SimpleSoundSpec | nil
  dug: SimpleSoundSpec | nil
  dug_deep: SimpleSoundSpec | nil
end

global enum NodeBoxType
  "regular"
  "fixed"
  "connected"
end

global type Box = {number}

global record NodeBoxRegular 
  type: NodeBoxType -- "regular"
end

global record NodeBoxFixed
  type: NodeBoxType -- "fixed"
  -- technically: Box | {Box}
  fixed: any | {Box}
end

global record NodeBoxConnected
  type: NodeBoxType -- "connected"
  -- technically: Box | {Box}
  fixed: any | {Box}
  -- technically: Box | {Box}
  connect_top: any | {Box}
  -- technically: Box | {Box}
  connect_bottom: any | {Box}
  -- technically: Box | {Box}
  connect_front: any | {Box}
  -- technically: Box | {Box}
  connect_left: any | {Box}
  -- technically: Box | {Box}
  connect_right: any | {Box}
  -- technically: Box | {Box}
  connect_back: any | {Box}
end

-- technically: NodeBoxRegular | NodeBoxFixed | NodeBoxConnected
global type NodeBox = any

global record NodeDefinition
  drawtype: DrawType
  visual_scale: number | nil
  -- should technically have lengths of 1, 2, or 6 
  tiles: {TileDefinition}
  special_tiles: {string} | nil
  use_texture_alpha: NodeDefinitionUseTextureAlpha | nil
  alpha: number | nil
  post_effect_color: ColorSpec | nil
  -- technically array of length 3 is only allowed
  inventory_image: string | {string} | nil
  
  -- technically array of length 3 is only allowed
  wield_image: string | {string} | nil
  paramtype: NodeDefinitionParamType | nil
  paramtype2: NodeDefinitionParamType2 | nil
  is_ground_content: boolean | nil
  sunlight_propagates: boolean | nil
  walkable: boolean | nil
  pointable: boolean | nil
  diggable: boolean | nil
  climbable: boolean | nil
  buildable_to: boolean | nil
  groups: { string: number } | nil

  -- technically it should be Item | {Item} | NodeDefinitionDrop | nil
  drop: Item | {Item} | any | nil
  stack_max: number | nil
  liquidtype: NodeDefinitionLiquidType | nil
  liquid_alternative_flowing: any | nil
  liquid_alternative_source: any | nil
  liquid_viscosity: number | nil
  liquid_renewable: boolean | nil
  light_source: number | nil
  damage_per_second: number | nil
  node_box: NodeBox | nil
  selection_box: NodeBox | nil
  collision_box: NodeBox | nil
  sounds: NodeDefinitionSounds | nil
  on_construct: nil | function(pos: Vector3D): nil
  on_destruct: nil | function(pos: Vector3D): nil
  after_destruct: nil | function(pos: Vector3D, oldnode: Node): nil
  on_place: nil | function(
    item: ItemStack,
    placer: ObjectRef,
    pos: Vector3D,
    pointedthing: PointedNode
  ): nil
  on_drop: nil | function(item: ItemStack, dropper: ObjectRef, pos: Vector3D): nil
  on_use: nil | function(
    item: ItemStack,
    player: ObjectRef,
    pointedthing: PointedNode
  ): nil
  on_punch: nil | function(
    item: ItemStack,
    node: Node,
    player: ObjectRef,
    pointedthing: PointedNode
  ): nil
  on_dig: nil | function(pos: Vector3D, node: Node, player: ObjectRef): nil
  on_timer: nil | function(pos: Vector3D, elapsed: number): nil
  on_receive_fields: nil | function(
    pos: Vector3D,
    formname: any,
    fields: { string: any },
    sender: PlayerObject
  ): nil
  allow_metadata_inventory_move: nil | function(
    pos: Vector3D,
    from_list: string,
    from_index: number,
    to_list: string,
    to_index: number,
    count: number,
    player: PlayerObject
  ): nil
  allow_metadata_inventory_put: nil | function(
    pos: Vector3D,
    listname: string,
    index: number,
    stack: ItemStack,
    player: PlayerObject
  ): nil
  allow_metadta_inventory_take: nil | function(
    pos: Vector3D,
    listname: string,
    index: number,
    stack: ItemStack,
    player: PlayerObject
  ): nil
  on_metadata_inventory_move: nil | function(
    pos: Vector3D,
    from_list: string,
    from_index: number,
    to_list: string,
    to_index: number,
    count: number,
    player: PlayerObject
  ): nil
  on_metadata_inventory_put: nil | function(
    pos: Vector3D,
    listname: string,
    index: number,
    stack: ItemStack,
    player: PlayerObject
  ): nil
  on_metadta_inventory_take: nil | function(
    pos: Vector3D,
    listname: string,
    index: number,
    stack: ItemStack,
    player: PlayerObject
  ): nil

  after_place_node: nil | function(
    pos: Vector3D,
    placer: ObjectRef | nil,
    itemstack: ItemStack,
    pointed_thing: PointedNode
  ): boolean | nil
  can_dig: nil | function(pos: Vector3D, player: PlayerObject): nil
  after_dig_node: nil | function(
    pos: Vector3D,
    oldnode: Node,
    old_meta: MetaDataRef,
    digger: ObjectRef
  ): nil
  on_rightclick: nil | function(
    pos: Vector3D,
    node: Node,
    player: PlayerObject,
    stack: ItemStack,
    pointed: PointedNode
  ): nil

  on_blast: nil | function(pos: Vector3D, intensity: number | nil): nil
end


-- @todo: fill this out
global record PlayerObject

end
