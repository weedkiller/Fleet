SET QUOTED_IDENTIFIER ON ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SelectInstructions]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_SelectInstructions]਍ഀ
GO਍ഀ
਍ഀ
਍ഀ
਍ഀ
create procedure sp_SelectInstructions਍ഀ
(਍ഀ
		@OrgId int਍ഀ
)਍ഀ
AS਍ഀ
	set nocount on਍ഀ
਍ഀ
	select 	OI.[Id],਍ഀ
		OI.TypeId,਍ഀ
		OIT.vchName as vchTypeName,਍ഀ
		OI.vchNote as vchInstructionText਍ഀ
	from OperatorInstructions OI਍ഀ
	inner join OperatorInstructionTypes OIT਍ഀ
	on OI.OrgId = @OrgId਍ഀ
	and OI.TypeId = OIT.[Id]਍ഀ
਍ഀ
GO਍ഀ
SET QUOTED_IDENTIFIER OFF ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
