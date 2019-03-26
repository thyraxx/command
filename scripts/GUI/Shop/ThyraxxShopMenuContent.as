class ThyraxxShopMenuContent : UpgradeShopMenuContent
{

	Widget@ m_wTemplate;
	Upgrades::ThyraxxItemPickerShop@ m_itemShop;

	ThyraxxShopMenuContent(ShopMenu@ shopMenu, string id = "thyraxxcustomshop")
	{
		super(shopMenu, id);

		@m_itemShop = cast<Upgrades::ThyraxxItemPickerShop>(m_currentShop);
		if (m_itemShop is null)
			PrintError("\"" + id + "\" is not a dungeon shop!");
	}

	string GetGuiFilename() override
	{
		return "gui/shop/thyraxxcustomshop.gui";
	}

	void OnShow() override
	{
		@m_wItemTemplate = m_widget.GetWidgetById("buy-template");
		@m_wItemTemplateSmall = m_widget.GetWidgetById("buy-template-small");
		@m_wItemList = m_widget.GetWidgetById("buy-list");
		@m_wItemListSmallContainer = m_widget.GetWidgetById("small-buy-list-container");
		@m_wItemListSmall = m_widget.GetWidgetById("small-buy-list");

		@m_wSoldOut = m_widget.GetWidgetById("sold-out");

		ReloadList();
	}

	bool BuyItem(Upgrades::Upgrade@ upgrade, Upgrades::UpgradeStep@ step) override
	{
		if (UpgradeShopMenuContent::BuyItem(upgrade, step))
		{
			auto record = GetLocalPlayerRecord();
			if (cast<Upgrades::ItemUpgrade>(upgrade) !is null){
				record.generalStoreItemsBought++;
			}
			return true;
		}
		return false;
	}

	Widget@ AddItem(Widget@ template, Widget@ list, Upgrades::Upgrade@ upgrade) override
	{
		auto wNewItem = UpgradeShopMenuContent::AddItem(template, list, upgrade);

		auto itemUpgrade = cast<Upgrades::ItemUpgrade>(upgrade);
		if (itemUpgrade !is null)
		{
			auto wIconContainer = cast<RectWidget>(wNewItem.GetWidgetById("icon-container"));
			if (wIconContainer !is null && itemUpgrade.m_item.quality != ActorItemQuality::Common)
			{
				vec4 qualityColor = GetItemQualityColor(itemUpgrade.m_item.quality);
				ColorHSV hsv(qualityColor);
				hsv.m_saturation *= 0.5f;
				hsv.m_value *= 0.35f;
				wIconContainer.m_color = tocolor(hsv.ToColorRGBA());
			}

			auto wIcon = cast<UpgradeIconWidget>(wNewItem.GetWidgetById("icon"));
			if (wIcon !is null)
				wIcon.Set(itemUpgrade.m_step);

			auto wButton = cast<UpgradeShopButtonWidget>(wNewItem.GetWidgetById("button"));
			if (wButton !is null && wButton.m_enabled)
			{
				auto record = GetLocalPlayerRecord();
				wButton.m_enabled = wButton.m_enabled && (record.generalStoreItemsBought < m_itemShop.m_maxItems);
			}
		}
		else
		{
			auto wButton = cast<UpgradeShopButtonWidget>(wNewItem);
			if (wButton !is null){
				wButton.m_enabled = wButton.m_enabled && !upgrade.IsOwned(GetLocalPlayerRecord());
			}
		}
		return wNewItem;
	}
}