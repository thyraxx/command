namespace WorldScript
{
	[WorldScript color="238 232 170" icon="system/icons.png;256;0;32;32"]
	class SpawnItem
	{
		vec3 Position;

		[Editable]
		string ItemID;

		[Editable]
		bool Take;

		UnitPtr DoSpawn(int id = 0)
		{
			auto item = g_items.GetItem(ItemID);
			if (item is null)
			{
				PrintError("Couldn't find item with ID \"" + ItemID + "\"!");
				return UnitPtr();
			}

			if (Take)
				item.inUse = true;

			auto prod = Resources::GetUnitProducer("items/item_specific.unit");
			auto unit = prod.Produce(g_scene, Position, id);

			auto b = cast<Item>(unit.GetScriptBehavior());
			b.Initialize(item);

			return unit;
		}

		SValue@ ServerExecute()
		{
			UnitPtr unit = DoSpawn();

			SValueBuilder builder;
			builder.PushInteger(unit.GetId());
			return builder.Build();
		}

		void ClientExecute(SValue@ val)
		{
			DoSpawn(val.GetInteger());
		}
	}
}
