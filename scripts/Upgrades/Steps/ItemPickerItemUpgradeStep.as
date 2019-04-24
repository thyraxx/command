namespace Upgrades
{
	class ItemPickerItemUpgradeStep : ItemUpgradeStep
	{
	
		ItemPickerItemUpgradeStep(ActorItem@ item, Upgrade@ upgrade, SValue@ params, int level)
		{
			super(item, upgrade, params, level);
		}

		void PayForUpgrade(PlayerRecord@ record) override
		{
			print(m_item.quality);
			if (CanAfford(record))
			{
				if(m_item.quality != 4 || m_item.quality != 5){
					Stats::Add("items-bought", 1, record);				
					Stats::Add("items-bought-" + GetItemQualityName(m_item.quality), 1, record);
					
					record.itemsBought.insertLast(m_item.id);
				}
			}

			UpgradeStep::PayForUpgrade(record);
		}
	}
}
