namespace Upgrades
{
    class MyDungeonShop : DungeonShop
    {
        MyDungeonShop(SValue& params)
        {
            super(params);
        }

        float GetCostScale() override
        {
            return 0.0001f;
        }

        void OnOpenMenu(int shopLevel, PlayerRecord@ record) override
        {
            ItemShop::OnOpenMenu(shopLevel, record);

            if (record !is null)
            // TODO: Only 1 item should be allowed to pick, but m_maxItems needs to
            // reset for normal dungeon items
                m_maxItems = 130;
        }

        void NewItems(SValue@ sv, PlayerRecord@ record) override
        {
            ItemShop::NewItems(sv, record);

            float costScale = GetParamFloat(UnitPtr(), sv, "cost-scale", false, 0.0001f);

            auto arrQualities = GetParamArray(UnitPtr(), sv, "qualities");

            auto itemQuality = g_items.m_allItemsList;
            for(int k = 0; k < 47; k++)
            {
                ActorItemQuality shopitem = ParseActorItemQuality(itemQuality[k].quality);
                if(shopitem == ActorItemQuality::Common)
                {
                    print(itemQuality[k].quality +": "+ itemQuality[k].name + " -> " + itemQuality[k].inUse);
                    AddNewItem(ActorItemQuality::Common, costScale, record);
                // if(shopitem == ){
                // if(itemQuality[k].inUse == false){
                    // if((itemQuality[k].inUse == false) && (itemQuality[k].quality == ActorItemQuality::Common)){
                        // i++;
                        
                }
            }


            // for (int i = 0; i < 2; i++)
            // {
            //     int index = randi(arrQualities.length());
            //     ActorItemQuality quality = ParseActorItemQuality(arrQualities[index].GetString());
                
            //     AddNewItem(quality, costScale, record);
            // }

            if (record !is null && record.items.find("fancy-plume") != -1)
                AddPlumeItem(costScale, record);

            record.generalStoreItemsBought = 0;
        }

    }
}