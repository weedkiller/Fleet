SET QUOTED_IDENTIFIER ON ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SelectMeasuresList]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)਍ഀ
drop procedure [dbo].[sp_SelectMeasuresList]਍ഀ
GO਍ഀ
਍ഀ
਍ഀ
create procedure sp_SelectMeasuresList਍ഀ
as਍ഀ
	set nocount on਍ഀ
	select * ਍ഀ
	from UnitMeasures਍ഀ
਍ഀ
਍ഀ
GO਍ഀ
SET QUOTED_IDENTIFIER OFF ਍ഀ
GO਍ഀ
SET ANSI_NULLS ON ਍ഀ
GO਍ഀ
਍ഀ
