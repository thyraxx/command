namespace ItemPicker
{
	[Hook]
	void GameModeStart(Campaign@ campaign, SValue@ save){
		// Only so these items won't appear in the sarcophagus
		g_items.GetItem("item-picker-common").inUse = true;
		g_items.GetItem("item-picker-uncommon").inUse = true;
		g_items.GetItem("item-picker-rare").inUse = true;
		g_items.GetItem("item-picker-epic").inUse = true;
		g_items.GetItem("item-picker-legendary").inUse = true;
	}
}