class ItemPickerItem : Item
{

	ItemPickerItem(UnitPtr unit, SValue& params)
	{
		params.GetDictionary().set("specific", true);

		super(unit, params);

		m_unit = unit;
		auto quality = ParseActorItemQuality(GetParamString(unit, params, "quality", false, "common"));

		bool specific = GetParamBool(unit, params, "specific", false, false);
		
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
	
	void Use(PlayerBase@ player) override
	{
		m_unit.Destroy();
		GiveItemImpl(m_item);
	}
}

void GiveItemImpl(ActorItem@ item)
{
	auto gm = cast<Campaign>(g_gameMode);

	if (item.quality == ActorItemQuality::Common)
		gm.m_shopMenu.Show(gm.m_shopMenu.m_shopArea, ItemPickerShopMenuContent(gm.m_shopMenu), 1);
	else if (item.quality == ActorItemQuality::Uncommon)
		gm.m_shopMenu.Show(gm.m_shopMenu.m_shopArea, ItemPickerShopMenuContent(gm.m_shopMenu), 2);
	else if (item.quality == ActorItemQuality::Rare)
		gm.m_shopMenu.Show(gm.m_shopMenu.m_shopArea, ItemPickerShopMenuContent(gm.m_shopMenu), 3);
	else if (item.quality == ActorItemQuality::Epic)
		gm.m_shopMenu.Show(gm.m_shopMenu.m_shopArea, ItemPickerShopMenuContent(gm.m_shopMenu), 4);
	else if (item.quality == ActorItemQuality::Legendary)
		gm.m_shopMenu.Show(gm.m_shopMenu.m_shopArea, ItemPickerShopMenuContent(gm.m_shopMenu), 5);
}
