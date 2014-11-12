
CREATE PROCEDURE pr_consulta_plano_teste

@cd_menu int

AS

declare @SQL varchar(2000),
        @cd_item int,
        @cd_grupo_plano_teste int,
        @cd_plano_teste int

set @SQL = ''

SELECT     
  cast(pt.cd_plano_teste as varchar) + ' - ' + pt.nm_plano_teste as CodPlano, 
  cast(gpt.cd_grupo_plano_teste as varchar)+ ' - ' + gpt.nm_grupo_plano_teste as CodGrupo,
  cast(null as varchar(2000)) as cd_itens,
  pt.cd_plano_teste,
  gpt.cd_grupo_plano_teste
into
  #Menu_Teste
FROM         
  Menu_Teste mt inner join
  Plano_Teste pt ON mt.cd_plano_teste = pt.cd_plano_teste inner join
  Grupo_Plano_Teste gpt ON mt.cd_plano_teste = gpt.cd_plano_teste
where
  mt.cd_menu = @cd_menu and
  exists ( select top 1 'x' from Item_Plano_Teste i
            where i.cd_plano_teste = pt.cd_plano_teste and
                  i.cd_grupo_plano_teste = gpt.cd_grupo_plano_teste ) 
order by
   pt.cd_plano_teste

SELECT     
  pt.cd_plano_teste,
  gpt.cd_grupo_plano_teste
into
  #Menu_Teste2
FROM         
  Menu_Teste mt left outer join
  Plano_Teste pt ON mt.cd_plano_teste = pt.cd_plano_teste left outer join
  Grupo_Plano_Teste gpt ON mt.cd_plano_teste = gpt.cd_plano_teste
where
  mt.cd_menu = @cd_menu
order by
   pt.cd_plano_teste


while exists ( select top 1 'x' from #Menu_Teste2 )
begin

  set @cd_grupo_plano_teste = ( select top 1 cd_grupo_plano_teste from #Menu_Teste2 order by cd_plano_teste, cd_grupo_plano_teste)
  set @cd_plano_teste = ( select top 1 cd_plano_teste from #Menu_Teste2 order by cd_plano_teste, cd_grupo_plano_teste)

  select i.cd_item_plano_teste
  into #Item_Plano_Teste 
  FROM         
    item_plano_teste i 
  where
    i.cd_plano_teste = @cd_plano_teste      and
    i.cd_grupo_plano_teste = @cd_grupo_plano_teste
  order by
     i.cd_plano_teste

  if exists ( select top 1 'x' from #Item_Plano_Teste )
  begin
    set @cd_item = ' ' + ( select top 1 cd_item_plano_teste from #Item_Plano_Teste order by cd_item_plano_teste)

    set @SQL = @SQL + cast(@cd_item as varchar)
    delete from #Item_Plano_teste where cd_item_plano_teste = @cd_item 
  end
             
  while exists ( select top 1 'x' from #Item_Plano_Teste ) 
  begin
    set @cd_item = ( select top 1 cd_item_plano_teste from #Item_Plano_Teste order by cd_item_plano_teste)

    set @SQL = @SQL + ' | ' + cast(@cd_item as varchar)
 
    delete from #Item_Plano_teste where cd_item_plano_teste = @cd_item 

  end

  update #Menu_Teste
  set cd_itens = @SQL + ' ' 
  where cd_plano_teste = @cd_plano_teste and
        cd_grupo_plano_teste = @cd_grupo_plano_teste

  delete #Menu_Teste2
  where cd_plano_teste = @cd_plano_teste and
        cd_grupo_plano_teste = @cd_grupo_plano_teste


  set @SQL = ' '

  drop table #Item_Plano_Teste 

end

select * from #Menu_Teste order by CodPlano, CodGrupo

