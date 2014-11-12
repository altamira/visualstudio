CREATE FUNCTION fn_mascara_produto
(@cd_produto int)
RETURNS varchar(50)

AS
BEGIN

	declare @cd_mascara_grupo_produto varchar(20),
			@cd_grupo_produto int,
			@cd_mascara_produto varchar(20)
	
	if IsNull(@cd_produto,0) > 0
	begin
		--Define o grupo de produto que o produto pertence
		select 
		top 1 
			@cd_grupo_produto = IsNull(cd_grupo_produto,0) ,
			@cd_mascara_produto = IsNull(cd_mascara_produto,'')
		from 
			produto 
		where 
			cd_produto = @cd_produto	
		--Define a mascara do grupo
		Select 
			@cd_mascara_grupo_produto = IsNull(cd_mascara_grupo_produto,'')
		from
			Grupo_Produto
		where cd_grupo_produto = @cd_grupo_produto
	
	
		if (@cd_mascara_grupo_produto <> '') and
			@cd_mascara_grupo_produto is not null and
			@cd_mascara_produto <> ''
			select @cd_mascara_produto = dbo.fn_formata_mascara(@cd_mascara_grupo_produto,@cd_mascara_produto)
	end
	else
		set @cd_mascara_produto = ''
return @cd_mascara_produto

end


