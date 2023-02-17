global dump : function(obj: any, indent : number | nil): string

global dump2: function(obj: any): string

global record RGBA
  r: number
  g: number
  b: number
  a: number | nil
end

global ColorSpec: number | string | RGBA


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
  ) : (ItemStack | void)
  on_use: nil | function(
    itemstack: ItemStack,
    user: ObjectRef | undefined,
    pointed_thing: PointedThing
  ) : (ItemStack | void)
  after_use: nil | function(
    itemstack: ItemStack,
    user: ObjectRef | undefined,
    node: Node,
    digparams: any
  ): (ItemStack | void)
  on_drop: nil | function(
    itemstack: ItemStack,
    dropper: ObjectRef | undefined,
    pos: Vector3D
  ) : (ItemStack | void)

end


global record ItemTable
  name: string
  count: number
  wear: number
  metadata: string
end

global record ItemStack
  add_item: function(item: Item): void
  add_wear: function(amount: number): void
  clear: function(): void
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
  replace: function(item: Item | string): void
  take_item: function(n: number | nil): ItemStack
  to_string: function(): string
  to_table: function(): any
end

-- technically Item is a union of ItemStack | ItemTable | string -- but that's not supported by the teal type system
global Item: any | string

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
  move_to: function(pos: Vector3D, continuous: boolean | nil): void
  punch: function(
    puncher: ObjectRef,
    time_from_last_punch: number,
    direction: Vector3D | nil
  ): void
  right_click: function(clicker: ObjectRef): void
  set_pos: function(pos: Vector3D): void
  set_armor_groups: function(groups: { string: any }): void
  set_hp: function(hitpoints: number): void
  set_wielded_item: function(item: Item): boolean
  set_animation: function(
    frame_range: Vector2D,
    frame_speed: number | nil,
    frame_blend: number | nil,
    frame_loop: boolean | nil
  ): void
  set_attach: function(
    parent: ObjectRef,
    bone: string | nil,
    position: Vector3D | nil,
    rotation: Vector3D | nil
  ): void
  set_detach: function(): void
  get_attach: function(): ObjectRefGetAttach
  set_bone_position: function(bone: string | nil, v1: Vector3D | nil, v2: Vector3D | nil): void
  set_properties: function(object_property_table: ObjectProperties): void
  get_properties: function(): Required<ObjectProperties>
  is_player: function(): boolean
  get_nametag_attributes: function(): ObjectRefGetNametagAttributes
  set_nametag_attributes: function(attributes: ObjectRefSetNametagAttributesArgs)
end
