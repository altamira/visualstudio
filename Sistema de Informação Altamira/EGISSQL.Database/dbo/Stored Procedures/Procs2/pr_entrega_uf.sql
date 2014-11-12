
create procedure pr_entrega_uf
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva/Luciano 
--Banco de Dados: SAPSQL
--Objetivo: Listagem de Notas Fiscais de Saida agrupados p/ Estado (UF)
--Data: 26/03/2002
--Atualizado: RAFAEL M. SANTIAGO -14/03/2003- Colocado o filtro por pais e por estado
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
-----------------------------------------------------------------------------------------
@cd_parametro int,
@dt_inicial datetime,
@dt_final   datetime,
@cd_pais    int,
@cd_estado  int
as

If @cd_parametro = 1
Begin

    select 
      distinct
--      n.cd_nota_saida,			--Nota                 

      case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
        n.cd_identificacao_nota_saida
      else
        n.cd_nota_saida                              
      end                           as cd_nota_saida,

      c.nm_fantasia_cliente,		--Fantasia Cliente	
      pa.nm_pais,
      pa.sg_pais,
      u.sg_estado,			--Uf		
      u.nm_estado,			--Estado	
      v.nm_fantasia_vendedor,		--Vendedor		
      n.dt_nota_saida, 			--Emissao
      n.vl_frete,
      n.vl_total,			--Valor
      t.nm_fantasia,       		--Transportadora	
      n.qt_volume_nota_saida , 		--Volume		
      n.qt_peso_bruto_nota_saida, 	--Peso Bruto
      n.qt_peso_liq_nota_saida		--Peso Liquido
    from 
      Nota_Saida n                      with (nolock) 
        left join
      Nota_Saida_Item i 
        on n.cd_nota_saida = i.cd_nota_saida
       inner join
      Entregador e
        on e.cd_entregador = n.cd_entregador
        left outer join
      Vendedor v 
        on v.cd_vendedor = n.cd_vendedor 
        left outer join
      Transportadora t  
        on n.cd_transportadora = t.cd_transportadora 
        Inner Join
      Cliente c 
        on c.cd_cliente = n.cd_cliente 
        Inner join
      Pais pa
        on c.cd_pais = pa.cd_pais
        Inner join
      Estado u 
        on c.cd_pais = u.cd_pais and
           c.cd_estado = u.cd_estado 

    where
      n.dt_nota_saida between @dt_inicial and @dt_final and
      ((c.cd_pais = @cd_pais) or (@cd_pais = 0)) and
      ((u.cd_estado = @cd_estado) or (@cd_estado = 0))
    order by
      pa.nm_pais, u.sg_estado, n.dt_nota_saida
     	
end 
If @cd_parametro = 2
Begin


  declare @vl_total_resumo decimal(25,2)

    select
      p.nm_pais                                        as 'Pais',
      p.cd_pais                                        as 'cd_pais',
      u.sg_estado                                      as 'UF',
      u.cd_estado                                      as 'cd_estado',
      count(n.cd_nota_saida)                           as 'Qtde',
      sum(n.vl_frete)                                  as 'ValorFrete',
      sum(n.vl_total)                                  as 'ValorTotal',
      max(n.dt_saida_nota_saida)                       as 'UltimaEntrega', 
      avg(e.vl_custo_entrega)                          as 'CustoUnitario',
      avg(e.vl_custo_entrega) * count(n.cd_nota_saida) as 'CustoTotal'
    into
      #Resumo_Estado
    from
      Nota_Saida n
       inner join
      Entregador e
        on e.cd_entregador = n.cd_entregador
        Inner Join  
      Cliente c 
        on c.cd_cliente = n.cd_cliente 
        Inner Join
      Pais p
        on c.cd_pais = p.cd_pais
        Inner join
      Estado u 
        on c.cd_pais = u.cd_pais and
           c.cd_estado = u.cd_estado 

    where
      n.dt_nota_saida between @dt_inicial and @dt_final and
      ((c.cd_pais = @cd_pais) or (@cd_pais = 0)) and
      ((u.cd_estado = @cd_estado) or (@cd_estado = 0))
    group by
      p.nm_pais,
      p.cd_pais,
      u.sg_estado,
      u.cd_estado

    -- total p/ cálculo do percentual

    select 
      @vl_total_resumo = isnull(sum(ValorTotal),1)
    from
      #Resumo_Estado

    select
      Pais,
      cd_pais,
      UF,
      cd_estado,
      Qtde,
      cast(ValorFrete as decimal(25,2))                                      as 'ValorFrete',
      cast(ValorTotal as decimal(25,2))                                      as 'ValorTotal',
      cast(((isnull(ValorTotal,1)/@vl_total_resumo) * 100) as decimal(25,2)) as 'Percentual',
      UltimaEntrega,
      cast(CustoUnitario as decimal(25,2))                                   as 'CustoUnitario',
      cast(CustoTotal as decimal(25,2))                                      as 'CustoTotal'
    from           
      #Resumo_Estado
    order by
      Pais, UF

End

