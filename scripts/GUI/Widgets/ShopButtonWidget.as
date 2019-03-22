class ShopButtonWidget : ScalableSpriteButtonWidget
{
	GUIDef@ m_def;

	Sprite@ m_spriteIconFrame;
	Sprite@ m_spriteIcon;
	Sprite@ m_itemDot;
	Sprite@ m_itemPlus;

	Sprite@ m_spriteGold;
	Sprite@ m_spriteOre;
	Sprite@ m_spriteSkillPoints;

	Sprite@ m_spriteCurrency;

	BitmapFont@ m_fontPrice;
	BitmapString@ m_textPrice;

	bool m_withIcon;

	bool m_canAfford;
	bool m_shopRestricted;

	ShopButtonWidget()
	{
		super();
	}

	void Load(WidgetLoadingContext &ctx) override
	{
		m_withIcon = ctx.GetBoolean("with-icon", false, true);

		if (m_withIcon)
			m_textOffset = vec2(36, -1);
		else
			m_textOffset = vec2(6, 0);

		ScalableSpriteButtonWidget::Load(ctx);

		@m_pressSound = null;

		@m_font = Resources::GetBitmapFont("gui/fonts/arial11.fnt");
		@m_fontPrice = Resources::GetBitmapFont("gui/fonts/arial11.fnt");

		@m_def = ctx.GetGUIDef();

		@m_spriteIconFrame = m_def.GetSprite("frame-icon");
		@m_spriteIcon = m_def.GetSprite(ctx.GetString("icon", false));
		@m_itemDot = m_def.GetSprite("item-dot");
		@m_itemPlus = m_def.GetSprite("item-plus");

		@m_spriteGold = m_def.GetSprite("gold");
		@m_spriteOre = m_def.GetSprite("ore");
		@m_spriteSkillPoints = m_def.GetSprite("skill-points");
	}

	Widget@ Clone() override
	{
		ShopButtonWidget@ w = ShopButtonWidget();
		CloneInto(w);
		return w;
	}

	int OwnedGold()
	{
		auto gm = cast<Campaign>(g_gameMode);

		if (cast<Town>(gm) is null)
			return GetLocalPlayerRecord().runGold;

		return gm.m_townLocal.m_gold;
	}

	int OwnedOre()
	{
		auto gm = cast<Campaign>(g_gameMode);

		if (cast<Town>(gm) is null)
			return GetLocalPlayerRecord().runOre;

		return gm.m_townLocal.m_ore;
	}

	void SetIcon(string icon)
	{
		@m_spriteIcon = m_def.GetSprite(icon);
	}

	void SetPriceGold(int amount)
	{
		@m_spriteCurrency = m_spriteGold;
		m_canAfford = (OwnedGold() >= amount);
		SetPrice(amount);
	}

	void SetPriceOre(int amount)
	{
		@m_spriteCurrency = m_spriteOre;
		m_canAfford = (OwnedOre() >= amount);
		SetPrice(amount);
	}

	void SetPriceSkillPoints(int amount)
	{
		@m_spriteCurrency = m_spriteSkillPoints;
		m_canAfford = (GetLocalPlayerRecord().GetAvailableSkillpoints() >= amount);
		SetPrice(amount);
	}

	void SetPrice(int amount)
	{
		if (amount != 0)
			@m_textPrice = m_fontPrice.BuildText(formatThousands(amount));
		else
			@m_textPrice = null;
	}

	void DrawIcon(SpriteBatch& sb, vec2 pos, vec4 color)
	{
		sb.DrawSprite(pos, m_spriteIconFrame, g_menuTime, color);
		if (m_spriteIcon !is null)
			sb.DrawSprite(pos + vec2(1, 1), m_spriteIcon, g_menuTime, color);
	}

	void UpdateEnabled()
	{
		m_enabled = (m_canAfford && !m_shopRestricted);
	}

	void DoDraw(SpriteBatch& sb, vec2 pos) override
	{
		ScalableSpriteButtonWidget::DoDraw(sb, pos);

		if (!m_enabled)
			sb.EnableColorize(vec4(0, 0, 0, 1), vec4(0.125, 0.125, 0.125, 1), vec4(0.25, 0.25, 0.25, 1));

		if (m_withIcon)
			DrawIcon(sb, pos + vec2(3, 3), vec4(1,1,1,1));

		if (!m_enabled)
			sb.DisableColorize();

		if (m_width > 64 && m_textPrice !is null)
		{
			if (m_canAfford)
				m_textPrice.SetColor(GetTextColor());
			else
				m_textPrice.SetColor(vec4(1, 0, 0, 1));

			vec2 spritePos;
			vec2 textPos;

			if (m_text is null)
			{
				int contentOffset = 0;
				if (m_withIcon)
					contentOffset = m_spriteIconFrame.GetWidth();

				int contentWidth = m_width - contentOffset;

				int currencyWidth = m_textPrice.GetWidth() + 2;
				if (m_spriteCurrency !is null)
					currencyWidth += m_spriteCurrency.GetWidth();

				textPos = vec2(
					pos.x + contentOffset + contentWidth / 2 - currencyWidth / 2,
					pos.y + m_height / 2 - m_textPrice.GetHeight() / 2 - 1
				);

				if (m_spriteCurrency !is null)
				{
					spritePos = vec2(
						textPos.x + m_textPrice.GetWidth() + 2,
						pos.y + m_height / 2 - m_spriteCurrency.GetHeight() / 2
					);
				}
			}
			else
			{
				if (m_spriteCurrency !is null)
				{
					spritePos = vec2(
						pos.x + m_width - m_spriteCurrency.GetWidth() - 8,
						pos.y + m_height / 2 - m_spriteCurrency.GetHeight() / 2
					);
					textPos = vec2(
						spritePos.x - m_textPrice.GetWidth() - 2,
						pos.y + m_height / 2 - m_textPrice.GetHeight() / 2 - 1
					);
				}
				else
				{
					textPos = vec2(
						pos.x + m_width - m_textPrice.GetWidth() - 10,
						pos.y + m_height / 2 - m_textPrice.GetHeight() / 2
					);
				}
			}

			if (m_spriteCurrency !is null)
				sb.DrawSprite(spritePos, m_spriteCurrency, g_menuTime);

			sb.DrawString(textPos, m_textPrice);
		}
	}
}

ref@ LoadShopButtonWidget(WidgetLoadingContext &ctx)
{
	ShopButtonWidget@ w = ShopButtonWidget();
	w.Load(ctx);
	return w;
}
