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
			ClearItems();
			this.shopLevel = shopLevel;
			
			// DungeonShop::OnOpenMenu(shopLevel, record);

			auto arr = GetParamArray(UnitPtr(), m_sval, "items");
			auto svalLevel = arr[shopLevel - 1];
		
			// if (record.generalStoreItemsSaved == GetItemCategory())
			// {
			// 	float costScale = GetParamFloat(UnitPtr(), svalLevel, "cost-scale", false, 0.0f);
			// 	ReadItems(costScale, record);
			// }
			// else
				NewItems(svalLevel, record);
			
			m_maxItems = 1;
		}

		void NewItems(SValue@ sv, PlayerRecord@ record) override
		{
			print("YEEEEEEEEEEEEEET");
            auto itemList = g_items.m_allItemsList;
		
			// auto localRecord = GetLocalPlayerRecord();
			// record.generalStoreItemsBought = 0;
			record.generalStoreItemsSaved = GetItemCategory();
			record.generalStoreItems.removeRange(0, record.generalStoreItems.length());
            
            // SValueBuilder builder;

            for(uint i = 0; i < itemList.length(); i++){
                auto item = itemList[i];

                // if(this.shopLevel == 1){
	                if(ActorItemQuality::Common == item.quality){
	                	print(record.items.find(item.id) + " -> " + item.inUse + " : " + item.name);
                		if(record.items.find(item.id) == -1){


		        	       	SValueBuilder builder;
		           			builder.PushDictionary();
		                	builder.PushString("id", "item-" + m_upgrades.length());
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
            	// }
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
            print(m_upgrades.length());
            record.generalStoreItemsBought = 0;

		}
	}
}
