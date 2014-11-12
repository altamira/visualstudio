

CREATE PROCEDURE pr_perda_proposta
@cd_cliente int,
@dt_inicial datetime,
@dt_final datetime,
@cd_concorrente int,
@cd_motivo_perda int,
@nm_fantasia_produto varchar(30)
AS

  Declare @SQL varchar(8000)

  set @SQL = 'Select 
              ci.cd_consulta,
              ci.cd_item_consulta,
              ci.nm_fantasia_produto,
              ci.qt_item_consulta,
              p.dt_perda_consulta,
              p.vl_perda_consulta,
              p.pc_perda_consulta,
              p.ds_perda_consulta,
              (Select nm_concorrente from Concorrente where cd_concorrente = p.cd_concorrente) as nm_concorrente,
              (Select nm_motivo_perda from Motivo_perda where cd_motivo_perda = p.cd_motivo_perda) as nm_motivo_perda
            From
	      Consulta_Itens ci inner join 
	      Consulta_Item_Perda p on
	      ci.cd_consulta = p.cd_consulta and ci.cd_item_consulta = p.cd_item_consulta
	      inner join Consulta c on ci.cd_consulta = c.cd_consulta '

   --Define a filtragem inicial
   set @SQL = @SQL + ' where p.dt_perda_consulta between ' + QuoteName(cast(@dt_inicial  as varchar),'''') + ' and ' + QuoteName(cast(@dt_final as varchar),'''')

   --Verifica se foi informado o cliente
   if (@cd_cliente > 0) and (not (@cd_cliente is null))
      set @SQL = @SQL + ' and c.cd_cliente = ' + cast(@cd_cliente as varchar)

   --Verifica se foi informado o concorrente
   if (@cd_concorrente > 0) and (not (@cd_concorrente is null))
      set @SQL = @SQL + ' and p.cd_concorrente = ' + cast(@cd_concorrente as varchar)


   --Verifica se foi informado o cliente
   if (@cd_motivo_perda > 0) and (not (@cd_motivo_perda is null))      set @SQL = @SQL +  ' and p.cd_motivo_perda = ' + cast(@cd_motivo_perda as varchar)

   if @nm_fantasia_produto != ''
      set @SQL = @SQL +  ' and ci.nm_fantasia_produto = ' + QuoteName(@nm_fantasia_produto,'''')

exec(@SQL)


