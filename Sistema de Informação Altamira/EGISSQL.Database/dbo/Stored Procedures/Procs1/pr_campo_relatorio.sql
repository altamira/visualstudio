
CREATE PROCEDURE pr_campo_relatorio
@ic_parametro int,
@cd_tabela int,
@cd_consulta_dinamica int

as

-------------------------------------------------------------------------------
if @ic_parametro = 1  -- LISTAGEM DAS TABELAS
-------------------------------------------------------------------------------
begin

  select 
    cd_tabela as CodTabela,    
    isnull(nm_tabela,'') as Tabela,
    ds_tabela as NomeTabela
  from EgisAdmin.dbo.Tabela tab
  where (nm_tabela like 'Produto%') or
    (nm_tabela like 'Operacao_Fiscal%') or
    (nm_tabela like 'Grupo_Produto%')
  order by 2

end
-------------------------------------------------------------------------------
else if @ic_parametro = 2  -- LISTAGEM DOS CAMPOS PARA O RELATÓRIO
-------------------------------------------------------------------------------
begin

  select 
    tab.cd_tabela as CodTabela,
    isnull(tab.nm_tabela,'') as Tabela, 
    atr.cd_atributo as CodCampo,

    case when isnull(atr.nm_atributo_relatorio,'') = '' then
      cast(atr.ds_atributo as varchar(100))
    else
      atr.nm_atributo_relatorio
    end as NomeCampo,

    isnull(tab.nm_tabela+'.'+atr.nm_atributo,'') as Campo, 

    isnull(tab.nm_tabela+'.'+(select top 1 nm_atributo 
                              from EgisAdmin.dbo.Atributo
                              where cd_tabela = tab.cd_tabela and
                                ic_atributo_chave = 'S' 
                              order by cd_atributo),'') as CampoChave,

    isnull(atr.nm_tabela_combo_box,'') as TabelaFK, 
    isnull(atr.nm_tabela_combo_box+'.'+atr.nm_campo_mostra_combo_box,'') as CampoFK, 
    isnull(atr.nm_tabela_combo_box+'.'+atr.nm_campo_chave_combo_box,'') as CampoFKChave
  from EgisAdmin.dbo.Tabela tab
    left outer join EgisAdmin.dbo.Atributo atr on tab.cd_tabela = atr.cd_tabela
  where tab.cd_tabela = @cd_tabela -- and
--    atr.ic_mostra_relatorio = 'S'
  order by 3

end
-------------------------------------------------------------------------------
else if @ic_parametro = 3  -- LISTAGEM DO SQL PARA RETORNO DOS DADOS
-------------------------------------------------------------------------------
begin

  SET NOCOUNT ON

  create table #SQL (
    Codigo int identity(1,1),
    Tipo int null,
      /** 1 - SELECT
          2 - FROM
          3 - WHERE
          4 - ORDER BY
      **/
    TabelaFrom varchar(100) null,
    SQL varchar(7000) null,
    SQLDigitado text null )

  if ((select len(ltrim(rtrim(cast(ds_instrucao_sql as varchar))))
       from EgisAdmin.dbo.Consulta_Dinamica
       where cd_consulta_dinamica = @cd_consulta_dinamica) <> 2)
  begin
    insert into #SQL 
    select 1, null, null, ds_instrucao_sql
    from EgisAdmin.dbo.Consulta_Dinamica
    where cd_consulta_dinamica = @cd_consulta_dinamica
  end
  else
  begin

    declare @Tabela varchar(100)
    declare @NomeCampo varchar(100)
    declare @Campo varchar(140)
    declare @CampoChave varchar(140)
    declare @TabelaFK varchar(100)
    declare @CampoFK varchar(140)
    declare @CampoFKChave varchar(140)
    declare @OrderBy char(1)
    declare @DescOrderBy char(1)
    declare @Where varchar(200)

    declare @TabelaAnt varchar(100)
    declare @TabelaFKAnt varchar(100)
    declare @CampoChaveAnt varchar(140)

    declare @SelectOk char(1)
    declare @OrderByOk char(1)
    declare @WhereOk char(1)

    declare @CampoCerto varchar(140)
    
    declare cCampos cursor for
    select 
      isnull(tab.nm_tabela,'') as Tabela, 

      case when isnull(cdi.nm_atributo,'') = '' then
        case when isnull(atr.nm_atributo_relatorio,'') = '' then
          cast(atr.ds_atributo as varchar(100))
        else
          atr.nm_atributo_relatorio
        end
      else
        cdi.nm_atributo
      end as NomeCampo,

      tab.nm_tabela+'.'+atr.nm_atributo as Campo, 

      isnull(tab.nm_tabela+'.'+(select top 1 nm_atributo 
                                from EgisAdmin.dbo.Atributo
                                where cd_tabela = tab.cd_tabela and
                                  ic_atributo_chave = 'S' 
                                order by cd_atributo),'') as CampoChave,

      isnull(atr.nm_tabela_combo_box,'') as TabelaFK, 
      isnull(atr.nm_tabela_combo_box+'.'+atr.nm_campo_mostra_combo_box,'') as CampoFK, 
      isnull(atr.nm_tabela_combo_box+'.'+atr.nm_campo_chave_combo_box,'') as CampoFKChave,
      isnull(cdi.ic_order_by,'N') as OrderBy,
      isnull(cdi.ic_desc_order_by,'N') as DescOrderBy,
      isnull(cdi.nm_filtro_atributo,'') as Filtro
    from EgisAdmin.dbo.Consulta_Dinamica_Item cdi
      left outer join EgisAdmin.dbo.Tabela tab on cdi.cd_tabela = tab.cd_tabela
      left outer join EgisAdmin.dbo.Atributo atr on tab.cd_tabela = atr.cd_tabela and
                                                    cdi.cd_atributo = atr.cd_atributo
    where cdi.cd_consulta_dinamica = @cd_consulta_dinamica
    order by isnull(cdi.cd_ordem_atributo,9999)
  
    open cCampos
    fetch next from cCampos into @Tabela, @NomeCampo, @Campo, @CampoChave, @TabelaFK, @CampoFK, @CampoFKChave, 
      @OrderBy, @DescOrderBy, @Where

    set @TabelaAnt = @Tabela
    set @TabelaFKAnt = ''
    set @CampoChaveAnt = @CampoChave
    set @SelectOK = 'S'
    set @OrderByOk = 'N'
    set @WhereOk = 'N'

    insert into #SQL values (2, @Tabela, 'FROM '+@Tabela+' WITH(NOLOCK)', null)

    while @@fetch_status = 0
    begin

      update #SQL set SQL = SQL + ','
      where Codigo = (select max(Codigo) from #SQL where Tipo = 1)

      if @CampoFK = '' 
        set @CampoCerto = @Campo
      else 
        set @CampoCerto = @CampoFK

      if (@SelectOK = 'S')
      begin
        insert into #SQL values (1, null, 'SELECT', null)
        insert into #SQL values (1, null, '  '+ @CampoCerto +' as ['+@NomeCampo+']', null)
      end
      else
        insert into #SQL values (1, null, '  '+ @CampoCerto +' as ['+@NomeCampo+']', null)

      set @SelectOK = 'N'
  
      if (@TabelaAnt <> @Tabela)
        if not exists(select TabelaFrom from #SQL where TabelaFrom = @Tabela)
        begin
          insert into #SQL values (2, @Tabela, '  LEFT OUTER JOIN '+@Tabela+' WITH(NOLOCK) on '+@CampoChave+' = '+@CampoChaveAnt, null) 
          set @TabelaAnt = @Tabela
          set @CampoChaveAnt = @CampoChave
        end

      if (isnull(@TabelaFK,'') <> '')
        if (@TabelaFKAnt <> @TabelaFK)
          if not exists(select TabelaFrom from #SQL where TabelaFrom = @TabelaFK)
          begin
            insert into #SQL values (2, @TabelaFK, '  LEFT OUTER JOIN '+@TabelaFK+' WITH(NOLOCK) on '+@Campo+' = '+@CampoFKChave, null) 
            set @TabelaFKAnt = @TabelaFK
          end

      if (@OrderBy = 'S')
      begin

        if (@OrderByOk = 'N')
        begin
          insert into #SQL values (4, null, 'ORDER BY ', null)
          set @OrderByOk = 'S'
        end
        else
          update #SQL set SQL = SQL + ','
          where Codigo = (select max(Codigo) from #SQL where Tipo = 4)

        if (@DescOrderBy = 'S')
          insert into #SQL values (4, null, '  '+@Campo+' DESC', null)
        else
          insert into #SQL values (4, null, '  '+@Campo, null)

      end

      if (@Where <> '')
      begin

        if (@WhereOK = 'N')
        begin
          insert into #SQL values (3, null, 'WHERE ', null)
          set @WhereOk = 'S'
        end
        else
          update #SQL set SQL = SQL + ' AND '
          where Codigo = (select max(Codigo) from #SQL where Tipo = 3)
      
        insert into #SQL values (3, null, '  '+@Campo+' = '+@Where, null)      

      end

      fetch next from cCampos into @Tabela, @NomeCampo, @Campo, @CampoChave, @TabelaFK, @CampoFK, @CampoFKChave, 
        @OrderBy, @DescOrderBy, @Where

    end

    close cCampos
    deallocate cCampos

  end

  select SQL, SQLDigitado from #SQL order by Tipo, Codigo

  drop table #SQL  

end
