class UpgradeShopButtonWidget : ShopButtonWidget
{
	ScriptSprite@ m_scriptSpriteIcon;

	Upgrades::Upgrade@ m_upgrade;
	Upgrades::UpgradeStep@ m_upgradeStep;

	UpgradeShopButtonWidget()
	{
		super();
	}

	Widget@ Clone() override
	{
		UpgradeShopButtonWidget@ w = UpgradeShopButtonWidget();
		CloneInto(w);
		return w;
	}

	void Load(WidgetLoadingContext &ctx) override
	{
		ShopButtonWidget::Load(ctx);
	}

	void Set(ShopMenuContent@ menuContent, Upgrades::Upgrade@ upgrade)
	{
		auto step = upgrade.GetNextStep(GetLocalPlayerRecord());
		if (step is null)
		{
			m_visible = false;
			return;
		}

		Set(menuContent, upgrade, step);
	}

	void Set(ShopMenuContent@ menuContent, Upgrades::Upgrade@ upgrade, Upgrades::UpgradeStep@ step)
	{
		@m_upgrade = upgrade;
		@m_upgradeStep = step;

		SetText(m_upgradeStep.GetButtonText());

		m_tooltipTitle = m_upgradeStep.GetTooltipTitle();
		m_tooltipText = m_upgradeStep.GetTooltipDescription();

		auto record = GetLocalPlayerRecord();

		float payScale = m_upgradeStep.PayScale(record);

		if (m_upgradeStep.m_costGold > 0)
			SetPriceGold(int(int(m_upgradeStep.m_costGold) * payScale));
		else if (m_upgradeStep.m_costOre > 0)
			SetPriceOre(int(int(m_upgradeStep.m_costOre) * payScale));
		else if (m_upgradeStep.m_costSkillPoints > 0)
			SetPriceSkillPoints(int(int(m_upgradeStep.m_costSkillPoints) * payScale));
		else
			SetPriceGold(0);

		//TODO: Show restriction reason somewhere
		m_shopRestricted = false;

		if (m_upgradeStep.m_restrictShopLevelMin != -1)
		{
			if (m_upgradeStep.m_restrictShopLevelMin > menuContent.m_shopMenu.m_currentShopLevel)
				m_shopRestricted = true;
		}

		if (m_upgradeStep.m_restrictPlayerLevelMin != -1)
		{
			if (m_upgradeStep.m_restrictPlayerLevelMin > record.level)
				m_shopRestricted = true;
		}

		if (m_upgradeStep.m_restrictFlag != "")
		{
			if (!g_flags.IsSet(m_upgradeStep.m_restrictFlag))
				m_shopRestricted = true;
		}

		if (!m_shopRestricted)
			m_shopRestricted = m_upgradeStep.IsRestricted();

		UpdateEnabled();
	}

	void DrawIcon(SpriteBatch& sb, vec2 pos, vec4 color) override
	{
		sb.DrawSprite(pos, m_spriteIconFrame, g_menuTime, color);

		if (m_scriptSpriteIcon !is null)
			m_scriptSpriteIcon.Draw(sb, pos + vec2(1, 1), g_menuTime, color);
		else if (m_upgradeStep.m_sprite !is null)
			m_upgradeStep.m_sprite.Draw(sb, pos + vec2(1, 1), g_menuTime, color);
		else if (m_upgrade.m_sprite !is null)
			m_upgrade.m_sprite.Draw(sb, pos + vec2(1, 1), g_menuTime, color);
		else
		{
			if (m_spriteIcon !is null)
				sb.DrawSprite(pos + vec2(1, 1), m_spriteIcon, g_menuTime, color);
			vec2 frameSize = vec2(m_spriteIconFrame.GetWidth() - 2, m_spriteIconFrame.GetHeight() - 2);
			m_upgradeStep.DrawShopIcon(this, sb, pos + vec2(1, 1), frameSize, color);
		}
	}
}

ref@ LoadUpgradeShopButtonWidget(WidgetLoadingContext &ctx)
{
	UpgradeShopButtonWidget@ w = UpgradeShopButtonWidget();
	w.Load(ctx);
	return w;
}
