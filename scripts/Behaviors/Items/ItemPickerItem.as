class ItemPickerItem : Item
{
	ItemPickerItem(UnitPtr unit, SValue& params)
	{
		params.GetDictionary().set("specific", true);

		super(unit, params);

		auto quality = ParseActorItemQuality(GetParamString(unit, params, "quality", false, "common"));

		string itemName = "item-picker-common";
		switch (quality)
		{
			case ActorItemQuality::Common: itemName = "item-picker-common"; break;
			case ActorItemQuality::Uncommon: itemName = "item-picker-uncommon"; break;
			case ActorItemQuality::Rare: itemName = "item-picker-rare"; break;
			case ActorItemQuality::Epic: itemName = "item-picker-epic"; break;
			case ActorItemQuality::Legendary: itemName = "item-picker-legendary"; break;
		}

		Initialize(g_items.GetItem(itemName));
	}

	void Use(PlayerBase@ player) override
	{
		m_unit.Destroy();

		int level = 1;
		switch (m_item.quality)
		{
			case ActorItemQuality::Common: level = 1; break;
			case ActorItemQuality::Uncommon: level = 2; break;
			case ActorItemQuality::Rare: level = 3; break;
			case ActorItemQuality::Epic: level = 4; break;
			case ActorItemQuality::Legendary: level = 5; break;
		}

		auto gm = cast<Campaign>(g_gameMode);
		gm.m_shopMenu.Show(gm.m_shopMenu.m_shopArea, ItemPickerShopMenuContent(gm.m_shopMenu), level);
	}
}
