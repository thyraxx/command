namespace Upgrades
{
	class ItemPickerItemUpgrade : ItemUpgrade
	{

		ItemPickerItemUpgrade(SValue& sval)
		{
			super(sval);
		}

		void Set(ItemShop@ shop, ActorItem@ item) override
		{
			m_quality = item.quality;

			@m_shop = shop;
			@m_item = item;

			SValueBuilder builder;
			builder.PushDictionary();
			builder.PushString("name", item.name);
			builder.PushString("desc", item.desc);

			@m_step = ItemPickerItemUpgradeStep(item, this, builder.Build(), 1);

			m_step.m_costGold = int(ceil(int(m_step.m_costGold) * m_costScale));
		}
	}
}
