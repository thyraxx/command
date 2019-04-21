namespace Upgrades
{
	class ItemPickerShop : ItemShop
	{
		int shopLevel;
		int m_maxItems;

		ItemPickerShop(SValue& params)
		{
			super(params);
		}

		void OnOpenMenu(int shopLevel, PlayerRecord@ record) override
		{
			this.shopLevel = shopLevel;
			
			ClearItems();
			print(m_upgrades.length());

			auto arr = GetParamArray(UnitPtr(), m_sval, "items");
			auto svalLevel = arr[shopLevel - 1];
		
			NewItems(svalLevel, record);

			m_maxItems = 1;	
		}

		void AddUpgradeToBuilder(ActorItemQuality itemQuality, PlayerRecord@ record){
			
			SValueBuilder builder;
   			builder.PushDictionary();
        	builder.PushString("id", "item-" + m_upgrades.length());
			builder.PushFloat("cost-scale", 0.0f);
        	
        	auto newUpgrade = ItemUpgrade(builder.Build());
            newUpgrade.m_quality = itemQuality;
            newUpgrade.Set(this);
            m_upgrades.insertLast(newUpgrade);
            
            // record.generalStoreItems.insertLast(newUpgrade.m_item.idHash);
		}

		void NewItems(SValue@ sv, PlayerRecord@ record) override
		{
			auto itemList = g_items.m_allItemsList;

			record.generalStoreItems.removeRange(0, record.generalStoreItems.length());
			m_upgrades.removeRange(0, m_upgrades.length());
			
            for(uint i = 0; i < itemList.length(); i++){
                auto item = itemList[i];

                if (item.requiredFlag != "" && !g_flags.IsSet(item.requiredFlag))
					continue;

				if (item.blockedFlag != "" && g_flags.IsSet(item.blockedFlag))
					continue;

				if (item.dlc == "pop" && !g_owns_dlc_pop)
					continue;

            	if(shopLevel == 1){
                	if(item.quality == ActorItemQuality::Common){
                		if(record.items.find(item.id) == -1 && item.id != "item-picker-common"){
		        	       AddUpgradeToBuilder(item.quality, record);
		                }
	                }
	            }

            	if(shopLevel == 2){
	                if(item.quality == ActorItemQuality::Uncommon){
	                	if(record.items.find(item.id) == -1 && item.id != "item-picker-uncommon"){
		        	    	AddUpgradeToBuilder(item.quality, record);	        	        
		                }
	                }
            	}

            	if(shopLevel == 3){
	                if(item.quality == ActorItemQuality::Rare){
	                	if(record.items.find(item.id) == -1 && item.id != "item-picker-rare"){
	        	      		AddUpgradeToBuilder(item.quality, record);		        	      
		                }
	                }
            	}

            	if(shopLevel == 4){
	                if(item.quality == ActorItemQuality::Epic){
	                	if(record.items.find(item.id) == -1 && item.id != "item-picker-epic"){
	        	        	AddUpgradeToBuilder(item.quality, record);
	        	    	}
	                }
            	}

            	if(shopLevel == 5){
	                if(item.quality == ActorItemQuality::Legendary){
	                	if(record.items.find(item.id) == -1 && item.id != "item-picker-legendary"){
		        	    	AddUpgradeToBuilder(item.quality, record);
		                }
	                }
            	}
        	}

        	
        	for(uint i = 0; i < m_upgrades.length(); i++){
        		int z = 0;
        		auto upgrad = cast<ItemUpgrade>(m_upgrades[i]);
        		for(uint k = 0; k < m_upgrades.length(); k++){
        			auto upgradzwei =  cast<ItemUpgrade>(m_upgrades[k]);
        			if(upgrad.m_item.name == upgradzwei.m_item.name){
        				z += 1;
        				if(z == 2){
        					print(upgrad.m_item.name + " is duplicate");
        				}
        			}
        		}
        	}
        	
        	// print(upgrad.m_item.name);
        	print(m_upgrades.length());
            record.generalStoreItemsBought = 0;
		}
	}
}
