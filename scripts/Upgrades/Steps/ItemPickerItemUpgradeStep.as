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
			if (CanAfford(record))
			{
				Stats::Add("items-bought", 1, record);	

				if(m_item.quality != 4){
					if(m_item.quality != 5){			
						Stats::Add("items-bought-" + GetItemQualityName(m_item.quality), 1, record);
					}
				}
				record.itemsBought.insertLast(m_item.id);
			}

			UpgradeStep::PayForUpgrade(record);
		}
	}
}
