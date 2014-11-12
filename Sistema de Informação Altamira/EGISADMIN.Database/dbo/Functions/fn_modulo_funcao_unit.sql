CREATE FUNCTION fn_modulo_funcao_unit
( @nm_unit_menu       varchar(100))

RETURNS varchar(1000)

as

begin

	declare @nm_result varchar(1000)
	declare @sg_modulo varchar(40)
	declare @nm_funcao varchar(40)

	set @nm_result = ''

	DECLARE cCursorMenu CURSOR FOR
	SELECT f.nm_funcao, m.sg_modulo FROM Modulo_Funcao_Menu mfm inner join
	Modulo m on mfm.cd_modulo = m.cd_modulo inner join Funcao f on
	mfm.cd_funcao = f.cd_funcao inner join Menu mn on mfm.cd_menu = mn.cd_menu
	where mn.nm_unit_menu = @nm_unit_menu
	
	OPEN cCursorMenu
	FETCH NEXT FROM cCursorMenu into @nm_funcao, @sg_modulo
	WHILE @@FETCH_STATUS = 0
	BEGIN   
-- 	   set @nm_result = @nm_result + rtrim(ltrim(IsNull(@sg_modulo,''))) + '->' + IsNull(@nm_funcao,'') + ', '
	   set @nm_result = @nm_result + ltrim(rtrim(IsNull(@sg_modulo,''))) + ', '
	   FETCH NEXT FROM cCursorMenu into @nm_funcao, @sg_modulo
	END
	CLOSE cCursorMenu
	DEALLOCATE cCursorMenu

    if len(@nm_result) - 2 > 0
		set @nm_result = substring(@nm_result, 1 , len(@nm_result) - 2)		

	return @nm_result

END



