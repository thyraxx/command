namespace Upgrades
{
	class ThyraxxItemPickerShop : ItemShop
	{
		int shopLevel;
		int m_maxItems;

		ThyraxxItemPickerShop(SValue& params)
		{
			super(params);
		}

		void OnOpenMenu(int shopLevel, PlayerRecord@ record) override
		{
			// print(shopLevel);
			// for(uint i = 0; i < record.itemsBought.length(); i++){
					// print(record.itemsBought.find[i]);
				// }
			ClearItems();
			this.shopLevel = shopLevel;

			auto arr = GetParamArray(UnitPtr(), m_sval, "items");
			auto svalLevel = arr[shopLevel - 1];
		
			if (record.generalStoreItemsSaved == GetItemCategory())
			{
				ReadItems(0.0f, record);
			}
			else
				NewItems(svalLevel, record);
			
			m_maxItems = 1;
		}

		void NewItems(SValue@ sv, PlayerRecord@ record) override
		{
	        auto itemList = g_items.m_allItemsList;

			// auto localRecord = GetLocalPlayerRecord();
			// record.generalStoreItemsBought = 0;
			record.generalStoreItemsSaved = GetItemCategory();
			record.generalStoreItems.removeRange(0, record.generalStoreItems.length());
			// m_upgrades.removeRange(0, m_upgrades.length());
            for(uint i = 0; i < itemList.length(); i++){
                auto item = itemList[i];

                if(this.shopLevel == 1){
                	if(record.generalStoreItemsBought < 1){
	                	if(item.quality == ActorItemQuality::Common){
		                	// print(record.items.find(item.id) + " -> " + item.inUse + " : " + item.name);
	                		if(record.itemsBought.find(item.id) == -1){
	                			print(record.itemsBought.find(item.id));


			        	       	SValueBuilder builder;
			           			builder.PushDictionary();
			                	builder.PushString("id", "item-" + m_upgrades.length());
			                	print(m_upgrades.length());
			        			builder.PushFloat("cost-scale", 0.0);
			                	
			                	// print(record.items.find(item.id));
			                	// print(record.items.find(item.name));
			                	// print(record.items.find(item.idHash));
			                	// print("InUSE: "+ item.inUse + " -> "+ item.name);

			                	
			                	auto newUpgrade = ItemUpgrade(builder.Build());
			                    newUpgrade.m_quality = item.quality;
			                    newUpgrade.Set(this);
			                    m_upgrades.insertLast(newUpgrade);
			                    

			                    record.generalStoreItems.insertLast(newUpgrade.m_item.idHash);
			                }
		                }
		            }
            	}
            // 	if(this.shopLevel == 2){
	           //      if(ActorItemQuality::Uncommon == item.quality){
	           //      	if(record.items.find(item.id) < 0 ){
		        	 //        // SValueBuilder builder;
		          //  			builder.PushDictionary();
		          //       	builder.PushString("id", "item-" + m_upgrades.length());
		        		// 	builder.PushFloat("cost-scale", 0.0);
	                	
	                	
		          //       	auto newUpgrade = ItemUpgrade(builder.Build());
		          //           newUpgrade.m_quality = item.quality;
		          //           newUpgrade.Set(this);
		          //           m_upgrades.insertLast(newUpgrade);

		          //           record.generalStoreItems.insertLast(newUpgrade.m_item.idHash);
		          //       }
	           //      }
            // 	}
            }
            // 
            // record.generalStoreItems.sortAsc();
            record.generalStoreItemsBought = 0;

		}

		void ReadItems(float costScale, PlayerRecord@ record) override
		{
			// costScale *= GetCostScale();

			for (uint i = 0; i < record.generalStoreItems.length(); i++)
			{
				auto item = g_items.GetItem(record.generalStoreItems[i]);
				if (item is null)
				{
					PrintError("Couldn't find item for hash!");
					continue;
				}

				SValueBuilder builder;
				builder.PushDictionary();
				builder.PushString("id", "item-" + i);
				builder.PushFloat("cost-scale", 0.0f);

				auto newUpgrade = ItemUpgrade(builder.Build());
				newUpgrade.Set(this, item);
				m_upgrades.insertLast(newUpgrade);
			}
		}
	}
}
