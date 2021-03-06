SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


ALTER  PROCEDURE sp_SelectComponentList
	(
		@OrgId int,
		@EquipId int
	)
AS
	set nocount on

	select 	EquipComponents.[Id] as ComponentId, 
		EquipComponents.[DataId], 
		EquipComponents.[TypeId] as TypeId,
		EquipComponentTypes.vchName as ComponentName,
		case when EquipComponents.btActive = 1 then 'Active' else 'Inactive (under repair)' end as Active,
		EquipData.[nvarchar1], 
		EquipData.[nvarchar2], 
		EquipData.[nvarchar3], 
		EquipData.[nvarchar4], 
		EquipData.[nvarchar5], 
		EquipData.[nvarchar6], 
		EquipData.[nvarchar7], 
		EquipData.[nvarchar8], 
		EquipData.[nvarchar9], 
		EquipData.[nvarchar10], 
		EquipData.[nvarchar11], 
		EquipData.[nvarchar12], 
		EquipData.[nvarchar13], 
		EquipData.[nvarchar14], 
		EquipData.[nvarchar15], 
		EquipData.[nvarchar16], 
		EquipData.[nvarchar17], 
		EquipData.[nvarchar18], 
		EquipData.[nvarchar19], 
		EquipData.[nvarchar20], 
		EquipData.[nvarchar21], 
		EquipData.[nvarchar22], 
		EquipData.[nvarchar23], 
		EquipData.[nvarchar24], 
		EquipData.[nvarchar25], 
		EquipData.[nvarchar26], 
		EquipData.[nvarchar27], 
		EquipData.[nvarchar28], 
		EquipData.[nvarchar29], 
		EquipData.[nvarchar30], 
		EquipData.[nvarchar31], 
		EquipData.[nvarchar32], 
		EquipData.[int1], 
		EquipData.[int2], 
		EquipData.[int3], 
		EquipData.[int4], 
		EquipData.[int5], 
		EquipData.[int6], 
		EquipData.[int7], 
		EquipData.[int8], 
		EquipData.[lookup1], 
		EquipData.[lookup2], 
		EquipData.[lookup3], 
		EquipData.[lookup4], 
		EquipData.[lookup5], 
		EquipData.[lookup6], 
		EquipData.[lookup7], 
		EquipData.[lookup8], 
		EquipData.[float1], 
		EquipData.[float2], 
		EquipData.[float3], 
		EquipData.[float4], 
		EquipData.[float5], 
		EquipData.[float6], 
		EquipData.[float7], 
		EquipData.[float8], 
		EquipData.[datetime1],
		EquipData.[datetime2],
		EquipData.[datetime3], 
		EquipData.[datetime4], 
		EquipData.[datetime5], 
		EquipData.[datetime6], 
		EquipData.[datetime7], 
		EquipData.[datetime8], 
		EquipData.[bit1], 
		EquipData.[bit2], 
		EquipData.[bit3], 
		EquipData.[bit4], 
		EquipData.[bit5], 
		EquipData.[bit6], 
		EquipData.[bit7], 
		EquipData.[bit8] 
	from EquipComponents
	inner join EquipData
	on EquipData.[Id] = EquipComponents.DataId
	and EquipData.OrgId = EquipComponents.OrgId 
	and EquipComponents.[EquipId] = @EquipId
	and EquipComponents.OrgId = @OrgId
	inner join EquipComponentTypes
	on EquipComponents.TypeId = EquipComponentTypes.[Id]
	order by EquipComponentTypes.vchName asc, EquipComponents.btActive desc
	
	return 


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

