class ItemPickerShopMenuContent : UpgradeShopMenuContent
{

	Widget@ m_wTemplate;
	Upgrades::ItemPickerShop@ m_itemShop;
	
	FilteredListWidget@ m_wList;
	TextInputWidget@ m_wFilter;

	ItemPickerShopMenuContent(ShopMenu@ shopMenu, string id = "itempickershop")
	{
		super(shopMenu, id);

		@m_itemShop = cast<Upgrades::ItemPickerShop>(m_currentShop);
		if (m_itemShop is null)
			PrintError("\"" + id + "\" is not a itempicker shop!");
	}

	string GetGuiFilename() override
	{
		return "gui/shop/itempickershop.gui";
	}

	bool ShouldShowStars() override
	{
		return false;
	}

	void OnShow() override
	{
		@m_wItemTemplate = m_widget.GetWidgetById("buy-template");
		@m_wItemTemplateSmall = m_widget.GetWidgetById("buy-template-small");

		@m_wItemListSmallContainer = m_widget.GetWidgetById("small-buy-list-container");
		@m_wItemListSmall = m_widget.GetWidgetById("small-buy-list");

		@m_wSoldOut = m_widget.GetWidgetById("sold-out");

		// Changed to filterlist
		@m_wList = cast<FilteredListWidget>(m_widget.GetWidgetById("buy-list"));
		@m_wFilter = cast<TextInputWidget>(m_widget.GetWidgetById("filter"));

		ReloadList();
	}

	void ReloadList() override
	{
		ClearList(m_wList);
		//ClearList(m_wItemListSmall);

		m_shopMenu.CloseTooltip();

		m_wItemListSmallContainer.m_visible = false;

		if (m_currentShop is null)
			return;

		auto record = GetLocalPlayerRecord();

		// Some debugging stuff
		//for(uint i = 0; i < record.generalStoreItems.length(); i++){
		//	print(g_items.GetItem(record.generalStoreItems[i]).id);
		//}

		m_currentShop.OnOpenMenu(m_shopMenu.m_currentShopLevel, record);

		int numItems = 0;
		for (auto iter = m_currentShop.Iterate(m_shopMenu.m_currentShopLevel, record); !iter.AtEnd(); iter.Next())
		{
			Widget@ btn = null;

			auto upgrade = iter.Current();
			
			// Cast to upgrade so we can actually retrieve the real name instead of
			// item-1, item-2, item-3, etc.
			auto itemUpgrade = cast<Upgrades::ItemPickerItemUpgrade>(upgrade);

			if (upgrade.m_small)
			{
				@btn = AddItem(m_wItemTemplateSmall, m_wItemListSmall, upgrade);
				m_wItemListSmallContainer.m_visible = true;
			}
			else
			{
				@btn = AddItem(m_wItemTemplate, m_wList, upgrade);
			}

			btn.m_filter = (Resources::GetString(itemUpgrade.m_item.name)).toLower();

			if (btn.m_visible)
				numItems++;
		}

		m_wSoldOut.m_visible = (numItems == 0);

		m_shopMenu.DoLayout();
		m_shopMenu.DoLayout();

		m_shopMenu.m_forceFocus = true;

	}


	bool BuyItem(Upgrades::Upgrade@ upgrade, Upgrades::UpgradeStep@ step) override
	{
		if (UpgradeShopMenuContent::BuyItem(upgrade, step))
		{
			m_shopMenu.Close();
			return true;
		}
		return false;
	}

	Widget@ AddItem(Widget@ template, Widget@ list, Upgrades::Upgrade@ upgrade) override
	{
		auto wNewItem = UpgradeShopMenuContent::AddItem(template, list, upgrade);

		auto itemUpgrade = cast<Upgrades::ItemPickerItemUpgrade>(upgrade);
		if (itemUpgrade !is null)
		{
			auto wIconContainer = cast<RectWidget>(wNewItem.GetWidgetById("icon-container"));
			if (wIconContainer !is null && itemUpgrade.m_item.quality != ActorItemQuality::Common)
			{
				vec4 qualityColor = GetItemQualityColor(itemUpgrade.m_item.quality);
				wIconContainer.m_color = desaturate(qualityColor);
			}

			auto wIcon = cast<UpgradeIconWidget>(wNewItem.GetWidgetById("icon"));
			if (wIcon !is null)
				wIcon.Set(itemUpgrade.m_step);

			auto wButton = cast<UpgradeShopButtonWidget>(wNewItem.GetWidgetById("button"));
			// wButton.m_enabled = true;

			if (wButton !is null)
			{
				auto record = GetLocalPlayerRecord();
				wButton.m_enabled = true;
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

	void OnFunc(Widget@ sender, string name) override
	{
		auto parse = name.split(" ");
		print(parse[0]);

		if (parse[0] == "buy-item")
		{
			auto btn = cast<UpgradeShopButtonWidget>(sender);
			if (btn !is null)
			{
				if (BuyItem(btn.m_upgrade, btn.m_upgradeStep))
					ReloadList();
			}
		}
		else if (parse[0] == "filterlist" )
			m_wList.SetFilter(m_wFilter.m_text.plain());
		else if (parse[0] == "filterlist-clear")
		{
			m_wFilter.ClearText();
			m_wList.ShowAll();
		}
		else
		{
			m_wFilter.ClearText();
			m_wList.ShowAll();
		}
	}
}