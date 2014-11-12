
CREATE procedure pr_resumo_comissao

@cd_parametro             int =0,      -- Tipo de Seleção do Resumo
@cd_vendedor              int =0,      -- Vendedor
@ano                      int =0,      -- Ano da pesquisa
@cd_tipo_vendedor         int =0       -- Tipo de Vendedor

as

declare @Sigla char(10)
declare @Setor char(30)

set @Sigla = null
set @Setor = null

-- ************
-- POR VENDEDOR
-- ************

if @cd_parametro = 0  -- Valor Bruto da Comissão por Vendedor
begin
     select a.cd_vendedor                 as 'Setor',
            month(b.dt_base_comissao)     as 'Mes',
            sum(a.vl_comissao)            as 'TotalComissao'
     -------
     into #Calculo_Comissao_0
     -------
     from
        Resumo_Comissao a,
        Parametro_Comissao b
     where 
        a.cd_parametro_comissao = b.cd_parametro_comissao and
        Year(b.dt_base_comissao) = @ano 

     Group by a.cd_vendedor, month(b.dt_base_comissao)
     Order by a.cd_vendedor, month(b.dt_base_comissao)

     -- Resumo em Forma de Grid Mês a Mês

     select b.nm_fantasia_vendedor as 'Setor',
            @Sigla as 'Sigla',
            sum( case a.mes when 1  then a.totalcomissao else 0 end ) as 'Jan',
            sum( case a.mes when 2  then a.totalcomissao else 0 end ) as 'Fev',
            sum( case a.mes when 3  then a.totalcomissao else 0 end ) as 'Mar',
            sum( case a.mes when 4  then a.totalcomissao else 0 end ) as 'Abr',
            sum( case a.mes when 5  then a.totalcomissao else 0 end ) as 'Mai',
            sum( case a.mes when 6  then a.totalcomissao else 0 end ) as 'Jun',
            sum( case a.mes when 7  then a.totalcomissao else 0 end ) as 'Jul',
            sum( case a.mes when 8  then a.totalcomissao else 0 end ) as 'Ago',
            sum( case a.mes when 9  then a.totalcomissao else 0 end ) as 'Set',
            sum( case a.mes when 10 then a.totalcomissao else 0 end ) as 'Out',
            sum( case a.mes when 11 then a.totalcomissao else 0 end ) as 'Nov',
            sum( case a.mes when 12 then a.totalcomissao else 0 end ) as 'Dez',
            sum( a.totalcomissao) as 'TotalGeral'

     from 
        #Calculo_Comissao_0 a 
     inner join Vendedor b
        on a.setor = b.cd_vendedor
     inner join Tipo_Vendedor c
        on b.cd_tipo_vendedor = c.cd_tipo_vendedor
           and c.ic_comissao_tipo_vendedor = 'S'
     where 
         IsNull(b.cd_tipo_vendedor,1) = ( case @cd_tipo_vendedor
                                            when 0 then IsNull(b.cd_tipo_vendedor,1)
                                            else @cd_tipo_vendedor
                                          end )

     group by b.nm_fantasia_vendedor

end

if @cd_parametro  = 1 -- Valor Sem Desconto da Comissão por Vendedor
begin
     select a.cd_vendedor                   as 'Setor',
            month(b.dt_base_comissao)       as 'Mes',
            sum(a.vl_comissao_sem_desconto) as 'TotalComissao'
     -------
     into #Calculo_Comissao_1
     -------
     from
        Resumo_Comissao a,
        Parametro_Comissao b
     where 
        a.cd_parametro_comissao = b.cd_parametro_comissao and
        Year(b.dt_base_comissao) = @ano 

     Group by a.cd_vendedor, month(b.dt_base_comissao)
     Order by a.cd_vendedor, month(b.dt_base_comissao)

     select b.nm_fantasia_vendedor as 'Setor',
            @Sigla as 'Sigla',
            sum( case a.mes when 1  then a.totalcomissao else 0 end ) as 'Jan',
            sum( case a.mes when 2  then a.totalcomissao else 0 end ) as 'Fev',
            sum( case a.mes when 3  then a.totalcomissao else 0 end ) as 'Mar',
            sum( case a.mes when 4  then a.totalcomissao else 0 end ) as 'Abr',
            sum( case a.mes when 5  then a.totalcomissao else 0 end ) as 'Mai',
            sum( case a.mes when 6  then a.totalcomissao else 0 end ) as 'Jun',
            sum( case a.mes when 7  then a.totalcomissao else 0 end ) as 'Jul',
            sum( case a.mes when 8  then a.totalcomissao else 0 end ) as 'Ago',
            sum( case a.mes when 9  then a.totalcomissao else 0 end ) as 'Set',
            sum( case a.mes when 10 then a.totalcomissao else 0 end ) as 'Out',
            sum( case a.mes when 11 then a.totalcomissao else 0 end ) as 'Nov',
            sum( case a.mes when 12 then a.totalcomissao else 0 end ) as 'Dez',
            sum(a.totalcomissao) as 'TotalGeral'
     
     from 
        #Calculo_Comissao_1 a
     inner join Vendedor b
        on a.setor = b.cd_vendedor
     inner join Tipo_Vendedor c
        on b.cd_tipo_vendedor = c.cd_tipo_vendedor
           and c.ic_comissao_tipo_vendedor = 'S'
     where 
         IsNull(b.cd_tipo_vendedor,1) = ( case @cd_tipo_vendedor
                                            when 0 then IsNull(b.cd_tipo_vendedor,1)
                                            else @cd_tipo_vendedor
                                          end )
     group by b.nm_fantasia_vendedor

end

if @cd_parametro = 2 -- Percentuais de Desconto da Comissão por Vendedor
begin
     select a.cd_vendedor                 as 'Setor',
            month(b.dt_base_comissao)     as 'Mes',
            avg(a.pc_desconto)            as 'PercDesconto'
     -------
     into #Calculo_Comissao_2
     -------
     from
        Resumo_Comissao a,
        Parametro_Comissao b
     where 
        a.cd_parametro_comissao = b.cd_parametro_comissao and
        Year(b.dt_base_comissao) = @ano 

     Group by a.cd_vendedor, month(b.dt_base_comissao)
     Order by a.cd_vendedor, month(b.dt_base_comissao)

     select b.nm_fantasia_vendedor as 'Setor',
            @Sigla as 'Sigla',
            avg( case a.mes when 1  then a.percdesconto else 0 end ) as 'Jan',
            avg( case a.mes when 2  then a.percdesconto else 0 end ) as 'Fev',
            avg( case a.mes when 3  then a.percdesconto else 0 end ) as 'Mar',
            avg( case a.mes when 4  then a.percdesconto else 0 end ) as 'Abr',
            avg( case a.mes when 5  then a.percdesconto else 0 end ) as 'Mai',
            avg( case a.mes when 6  then a.percdesconto else 0 end ) as 'Jun',
            avg( case a.mes when 7  then a.percdesconto else 0 end ) as 'Jul',
            avg( case a.mes when 8  then a.percdesconto else 0 end ) as 'Ago',
            avg( case a.mes when 9  then a.percdesconto else 0 end ) as 'Set',
            avg( case a.mes when 10 then a.percdesconto else 0 end ) as 'Out',
            avg( case a.mes when 11 then a.percdesconto else 0 end ) as 'Nov',
            avg( case a.mes when 12 then a.percdesconto else 0 end ) as 'Dez',
            avg(a.percdesconto) as 'TotalGeral'

     from 
        #Calculo_Comissao_2 a
     inner join Vendedor b
        on a.setor = b.cd_vendedor
     inner join Tipo_Vendedor c
        on b.cd_tipo_vendedor = c.cd_tipo_vendedor
           and c.ic_comissao_tipo_vendedor = 'S'
     where 
         IsNull(b.cd_tipo_vendedor,1) = ( case @cd_tipo_vendedor
                                            when 0 then IsNull(b.cd_tipo_vendedor,1)
                                            else @cd_tipo_vendedor
                                          end )
     group by b.nm_fantasia_vendedor

end

-- *************
-- POR CATEGORIA
-- *************

if @cd_parametro = 3 -- Valor Bruto da Comissão por Categoria
begin

     print 'selecionando dados do resumo'

     select c.sg_categoria_produto             as 'Sigla', 
            month(b.dt_base_comissao)          as 'Mes',                                    
            sum(a.vl_comissao)                 as 'TotalComissao'
     into #Calculo_Comissao_3
     from 
        Resumo_Comissao a,
        Parametro_Comissao b,
        Categoria_Produto c
     where
       (@cd_vendedor = 0 or
        a.cd_vendedor = @cd_vendedor) and
        a.cd_parametro_comissao = b.cd_parametro_comissao and
        Year(b.dt_base_comissao) = @ano and
        a.cd_categoria_produto = c.cd_categoria_produto

     Group by c.sg_categoria_produto, month(b.dt_base_comissao)
     Order by c.sg_categoria_produto, month(b.dt_base_comissao)

--     print 'totalizando'

     select a.Sigla,
            @Setor as 'Setor', 
            sum( case a.mes when 1  then a.totalcomissao else 0 end ) as 'Jan',
            sum( case a.mes when 2  then a.totalcomissao else 0 end ) as 'Fev',
            sum( case a.mes when 3  then a.totalcomissao else 0 end ) as 'Mar',
            sum( case a.mes when 4  then a.totalcomissao else 0 end ) as 'Abr',
            sum( case a.mes when 5  then a.totalcomissao else 0 end ) as 'Mai',
            sum( case a.mes when 6  then a.totalcomissao else 0 end ) as 'Jun',
            sum( case a.mes when 7  then a.totalcomissao else 0 end ) as 'Jul',
            sum( case a.mes when 8  then a.totalcomissao else 0 end ) as 'Ago',
            sum( case a.mes when 9  then a.totalcomissao else 0 end ) as 'Set',
            sum( case a.mes when 10 then a.totalcomissao else 0 end ) as 'Out',
            sum( case a.mes when 11 then a.totalcomissao else 0 end ) as 'Nov',
            sum( case a.mes when 12 then a.totalcomissao else 0 end ) as 'Dez',
            sum(a.totalcomissao) as 'TotalGeral'
     from #Calculo_Comissao_3 a
     group by a.sigla
     order by a.Sigla

end

if @cd_parametro = 4 -- Valor Sem Desconto da Comissão por Categoria
begin
     select c.sg_categoria_produto             as 'Sigla',
            month(b.dt_base_comissao)          as 'Mes',        
            sum(a.vl_comissao_sem_desconto)    as 'TotalComissao' 
     into #Calculo_Comissao_4
     from 
        Resumo_Comissao a,
        Parametro_Comissao b,
        Categoria_Produto c
     where
       (@cd_vendedor = 0 or
        a.cd_vendedor = @cd_vendedor) and
        a.cd_parametro_comissao = b.cd_parametro_comissao and
        Year(b.dt_base_comissao) = @ano  and
        a.cd_categoria_produto = c.cd_categoria_produto

     Group by c.sg_categoria_produto, month(b.dt_base_comissao)
     Order by c.sg_categoria_produto, month(b.dt_base_comissao)

     select a.Sigla,
            @Setor as 'Setor',
            sum( case a.mes when 1  then a.totalcomissao else 0 end ) as 'Jan',
            sum( case a.mes when 2  then a.totalcomissao else 0 end ) as 'Fev',
            sum( case a.mes when 3  then a.totalcomissao else 0 end ) as 'Mar',
            sum( case a.mes when 4  then a.totalcomissao else 0 end ) as 'Abr',
            sum( case a.mes when 5  then a.totalcomissao else 0 end ) as 'Mai',
            sum( case a.mes when 6  then a.totalcomissao else 0 end ) as 'Jun',
            sum( case a.mes when 7  then a.totalcomissao else 0 end ) as 'Jul',
            sum( case a.mes when 8  then a.totalcomissao else 0 end ) as 'Ago',
            sum( case a.mes when 9  then a.totalcomissao else 0 end ) as 'Set',
            sum( case a.mes when 10 then a.totalcomissao else 0 end ) as 'Out',
            sum( case a.mes when 11 then a.totalcomissao else 0 end ) as 'Nov',
            sum( case a.mes when 12 then a.totalcomissao else 0 end ) as 'Dez',
            sum(a.totalcomissao) as 'TotalGeral'
     from #Calculo_Comissao_4 a
     group by a.sigla
     order by a.Sigla

end

if @cd_parametro = 5 -- Percentuais de Desconto da Comissão por Categoria
begin
     select c.sg_categoria_produto             as 'Sigla',
            month(b.dt_base_comissao)          as 'Mes',        
            avg(a.pc_desconto)                 as 'PercDesconto'
     into #Calculo_Comissao_5
     from 
        Resumo_Comissao a,
        Parametro_Comissao b,
        Categoria_Produto c
     where 
       (@cd_vendedor = 0 or
        a.cd_vendedor = @cd_vendedor) and
        a.cd_parametro_comissao = b.cd_parametro_comissao and
        Year(b.dt_base_comissao) = @ano  and
        a.cd_categoria_produto = c.cd_categoria_produto

     Group by c.sg_categoria_produto, month(b.dt_base_comissao)
     Order by c.sg_categoria_produto, month(b.dt_base_comissao)

     select a.Sigla,
            @Setor as 'Setor',
            avg( case a.mes when 1  then a.PercDesconto else 0 end ) as 'Jan',
            avg( case a.mes when 2  then a.PercDesconto else 0 end ) as 'Fev',
            avg( case a.mes when 3  then a.PercDesconto else 0 end ) as 'Mar',
            avg( case a.mes when 4  then a.PercDesconto else 0 end ) as 'Abr',
            avg( case a.mes when 5  then a.PercDesconto else 0 end ) as 'Mai',
            avg( case a.mes when 6  then a.PercDesconto else 0 end ) as 'Jun',
            avg( case a.mes when 7  then a.PercDesconto else 0 end ) as 'Jul',
            avg( case a.mes when 8  then a.PercDesconto else 0 end ) as 'Ago',
            avg( case a.mes when 9  then a.PercDesconto else 0 end ) as 'Set',
            avg( case a.mes when 10 then a.PercDesconto else 0 end ) as 'Out',
            avg( case a.mes when 11 then a.PercDesconto else 0 end ) as 'Nov',
            avg( case a.mes when 12 then a.PercDesconto else 0 end ) as 'Dez',
            avg( a.PercDesconto ) as 'TotalGeral'
     from #Calculo_Comissao_5 a
     group by a.sigla
     order by a.Sigla

end

