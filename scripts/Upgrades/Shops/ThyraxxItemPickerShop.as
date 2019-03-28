namespace Upgrades
{
	class ThyraxxItemPickerShop : ItemShop
	{
		int shopLevels;
		int m_maxItems;

		ThyraxxItemPickerShop(SValue& params)
		{
			super(params);
		}

		void OnOpenMenu(int shopLevel, PlayerRecord@ record) override
		{
			ClearItems();
			this.shopLevels = shopLevel;

			auto arr = GetParamArray(UnitPtr(), m_sval, "items");
			auto svalLevel = arr[shopLevel - 1];
		
			// if (record.generalStoreItemsSaved == GetItemCategory())
			// {
			// 	ReadItems(0.0f, record);
			// }
			// else
				NewItems(svalLevel, record);
			
			m_maxItems = 1;
		}

		void NewItems(SValue@ sv, PlayerRecord@ record) override
		{
	        auto itemList = g_items.m_allItemsList;
			// record.generalStoreItemsSaved = GetItemCategory();
			record.generalStoreItems.removeRange(0, record.generalStoreItems.length());
			m_upgrades.removeRange(0, m_upgrades.length());
			
            for(uint i = 0; i < itemList.length(); i++){
                auto item = itemList[i];

                if(this.shopLevels == 1){
                	// if(record.generalStoreItemsBought < 1){
	                	if(item.quality == ActorItemQuality::Common){
	                		if(record.items.find(item.id) == -1){
			        	       	
			        	       	SValueBuilder builder;
			           			builder.PushDictionary();
			                	builder.PushString("id", "item-" + m_upgrades.length());
			                	print(m_upgrades.length());
			        			builder.PushFloat("cost-scale", 0.0f);
			                	
			                	// print(record.items.find(item.id));
			                	// print(record.items.find(item.name));
			                	// print(record.items.find(item.idHash));
			                	// print("InUSE: "+ item.inUse + " -> "+ item.name);

			                	// ActorItemQuality quality = ParseActorItemQuality(item.quality);
			                	// print(quality);
			                	auto newUpgrade = ItemUpgrade(builder.Build());
			                    newUpgrade.m_quality = item.quality;
			                    newUpgrade.Set(this);
			                    m_upgrades.insertLast(newUpgrade);
			                    

			                    record.generalStoreItems.insertLast(newUpgrade.m_item.idHash);

			                }
		                }
		            // }
	            }

            	if(this.shopLevels == 2){
	                if(item.quality == ActorItemQuality::Uncommon){
	                	if(record.items.find(item.id) == -1 ){
		        	        
		        	        SValueBuilder builder;
		           			builder.PushDictionary();
		                	builder.PushString("id", "item-" + m_upgrades.length());
		        			builder.PushFloat("cost-scale", 0.0);
	                	
	                	
		                	auto newUpgrade = ItemUpgrade(builder.Build());
		                    newUpgrade.m_quality = item.quality;
		                    newUpgrade.Set(this);
		                    m_upgrades.insertLast(newUpgrade);

		                    record.generalStoreItems.insertLast(newUpgrade.m_item.idHash);
		                }
	                }
            	}

            }
            // 
            // record.generalStoreItems.sortAsc();
            record.generalStoreItemsBought = 0;

		}
	}
}
