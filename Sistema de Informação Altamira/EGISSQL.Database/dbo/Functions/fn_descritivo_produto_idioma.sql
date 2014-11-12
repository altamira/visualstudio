
create FUNCTION fn_descritivo_produto_idioma
(@cd_produto int,
 @cd_idioma  int = 0)
returns varchar(8000)

-----------------------------------------------------------------------------------------
--fn_descritivo_produto_idioma
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2005
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)       : Elias Pereira da Silva
--Banco de Dados  : EgisSql
--Objetivo        : Retorna o Descritivo do Produto em seus vários idiomas
--Data            : 21/02/2005
--                : 01.12.2005
-----------------------------------------------------------------------------------------

as
begin

  
  declare @ds_produto_idioma varchar(500)
  declare @resultado         varchar(8000)
  set @resultado = ''

  declare cCursor cursor for

  select cast(ds_produto_idioma as varchar(500))
  from produto_idioma
  where cd_produto = @cd_produto
        and
        cd_idioma  = case when @cd_idioma = 0 then cd_idioma else @cd_idioma end 
  order by cd_idioma

  open cCursor 

  fetch next from cCursor into @ds_produto_idioma 

  while @@fetch_status = 0
  begin

    set @resultado = @resultado + cast(isnull(@ds_produto_idioma,'') as varchar(500))
    fetch next from cCursor into @ds_produto_idioma 

    if (isnull(@ds_produto_idioma,'') <> '')
      set @resultado = @resultado + char(13)

  end

  close cCursor
  deallocate cCursor

  --Caso estiver Vazio Busca a Descrição do Cadastro do produto em Português

  if isnull(@resultado,'') = '' 
  begin
     select @resultado = nm_produto 
     from
       Produto 
     where @cd_produto = cd_produto
  end

  return(@resultado)

end
