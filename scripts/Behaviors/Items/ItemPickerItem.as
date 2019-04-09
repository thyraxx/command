class ItemPickerItem : IUsable
{
	UnitPtr m_unit;
	ActorItem@ m_item;

	ItemPickerItem(UnitPtr unit, SValue& params)
	{
		m_unit = unit;
		auto quality = ParseActorItemQuality(GetParamString(unit, params, "quality", false, "common"));

		bool specific = GetParamBool(unit, params, "specific", false, false);

		if (!specific){
		
			if(quality == 1){
				Initialize(g_items.GetItem("item-picker-common"));
			}

			if(quality == 2){
				Initialize(g_items.GetItem("item-picker-uncommon"));
			}

			if(quality == 3){
				Initialize(g_items.GetItem("item-picker-rare"));
			}

			if(quality == 4){
				Initialize(g_items.GetItem("item-picker-epic"));
			}

			if(quality == 5){
				Initialize(g_items.GetItem("item-picker-legendary"));
			}
		}
	}

	void Initialize(ActorItem@ item)
	{
		if (item is null)
			return;

		@m_item = item;

		ScriptSprite@ sprite = m_item.iconScene;
		
		array<vec4> frames;
		array<int> frameTimes = { 100 };
		
		for (uint i = 0; i < sprite.m_frames.length(); i++)
			frames.insertLast(sprite.m_frames[i].frame);
		
		Material@ mat = GetQualityMaterial(item.quality);

		vec2 halfSize = vec2(
			sprite.GetWidth() / 2,
			sprite.GetHeight() / 2
		);
		
		CustomUnitScene unitScene;
		unitScene.AddScene(m_unit.GetUnitScene("shared"), 0, vec2(), 0, 0);
		unitScene.AddSprite(CustomUnitSprite(halfSize, sprite.m_texture, mat, frames, frameTimes, true, 0), 0, vec2(), 0, 0);
		
		m_unit.SetUnitScene(unitScene, false);
	}

	UnitPtr GetUseUnit()
	{
		return m_unit;
	}

	bool CanUse(PlayerBase@ player)
	{
		return true;
	}

	void NetUse(PlayerHusk@ player)
	{
	}

	UsableIcon GetIcon(Player@ player)
	{
		return UsableIcon::Generic;
	}

	int UsePriority(IUsable@ other) { return 1; }

	SValue@ Save()
	{
		SValueBuilder sval;
		sval.PushArray();
		sval.PushString(m_item.id);
		sval.PushString(m_unit.GetCurrentUnitScene().GetName());
		sval.PopArray();
		return sval.Build();
	}
	
	void PostLoad(SValue@ data)
	{
		if (data.GetType() == SValueType::Array)
		{
			auto arr = data.GetArray();
			Initialize(g_items.TakeItem(arr[0].GetString()));
			m_unit.SetUnitScene(arr[1].GetString(), false);
		}
		else if (data.GetType() == SValueType::String)
			Initialize(g_items.TakeItem(data.GetString()));

		if (m_item is null)
			m_unit.Destroy();
	}

	void Collide(UnitPtr unit, vec2 pos, vec2 normal, Fixture@ fxSelf, Fixture@ fxOther)
	{
		Player@ player = cast<Player>(unit.GetScriptBehavior());
		if (player is null)
			return;

		if (fxSelf.IsSensor())
			player.AddUsable(this);
	}

	void EndCollision(UnitPtr unit, Fixture@ fxSelf, Fixture@ fxOther)
	{
		Player@ player = cast<Player>(unit.GetScriptBehavior());
		if (player is null)
			return;

		if (fxSelf.IsSensor())
			player.RemoveUsable(this);
	}
	
	void Use(PlayerBase@ player)
	{
		m_unit.Destroy();
		GiveItemImpl(m_item);
	}
}

void GiveItemImpl(ActorItem@ item)
{
	auto gm = cast<Campaign>(g_gameMode);

	if (item.quality == ActorItemQuality::Common)
		gm.m_shopMenu.Show(ItemPickerShopMenuContent(gm.m_shopMenu), 1);
	else if (item.quality == ActorItemQuality::Uncommon)
		gm.m_shopMenu.Show(ItemPickerShopMenuContent(gm.m_shopMenu), 2);
	else if (item.quality == ActorItemQuality::Rare)
		gm.m_shopMenu.Show(ItemPickerShopMenuContent(gm.m_shopMenu), 3);
	else if (item.quality == ActorItemQuality::Epic)
		gm.m_shopMenu.Show(ItemPickerShopMenuContent(gm.m_shopMenu), 4);
	else if (item.quality == ActorItemQuality::Legendary)
		gm.m_shopMenu.Show(ItemPickerShopMenuContent(gm.m_shopMenu), 5);
}
