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

		// Fix for item not having a cost.
		// If an item doesn't have a cost it won't be added to the list :/
		for(uint i = 0; i < g_items.m_allItemsList.length(); i++)
		{
			if(g_items.m_allItemsList[i].cost == 0)
			{
				// Dirty fix, should actually also filter on quality
				// and change cost based on that.
				g_items.m_allItemsList[i].cost = 1000;
			}
		}
	}
}