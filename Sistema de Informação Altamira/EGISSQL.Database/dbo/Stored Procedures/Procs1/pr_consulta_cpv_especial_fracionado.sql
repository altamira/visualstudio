
CREATE  PROCEDURE pr_consulta_cpv_especial_fracionado

@cd_produto            int     = 0,    
@cd_grupo_produto      int     = 0,    
@cd_categoria_produto  int     = 0,     
@ic_importacao_produto char(1) = '',    
@dt_inicial            dateTime,    
@dt_final              dateTime,    
@cd_moeda              int     = 0,    
@vl_dolar_medio        float   = 1,
@ic_parametro          int     = 0,    
@ic_consulta_mov_venda char(1) = 'N',  --Consulta CPV/Produto sem Movimento de Venda    
@ic_tipo_produto       int     = 0,     --0 = Todos os Produtos // 1 = Somente os Produtos Originais // 2- FRACIONADOS
@cd_produto_original   int     = 0
                                         
AS      

--Gera o Cálculo de PIS/COFINS 
--Notas fiscais de Saída

exec pr_gera_calculo_pis_cofins_item_nota @dt_inicial,@dt_final

--Apenas Cria a Tabela Vazia

--Print 'Lista os Produtos EO'

select
	p.cd_produto             as Codigo,
	p.nm_fantasia_produto    as Fantasia,
	cast(0   as int )        as cd_produto_fracionado,
	cast(' ' as varchar(30)) as fantasiafracionado,
	cast(0   as int )        as cd_produto_embalagem,
	cast(1.0000 as float )   as qt_produto_embalagem

into #AuxProduto

from 
   Produto p                           with (nolock) 
   LEFT join Produto_Fracionamento pf  with (nolock) on pf.cd_produto_fracionado = p.cd_produto
                                                        and pf.cd_produto       <> p.cd_produto
where
	p.cd_produto = case when @cd_produto = 0 then p.cd_produto else @cd_produto end 
	-- retira os Fracionado Caso seja @ic_tipo_produto 1 ou 2
   and isnull(pf.cd_produto_fracionado, 0) = case when @ic_tipo_produto = 1 or @ic_tipo_produto = 2 then 0 else isnull(pf.cd_produto_fracionado,0)  end

--select * from produto_fracionamento where cd_produto = 872
--select * from produto_fracionamento where cd_produto_fracionado = 872

--select * from #AuxProduto order by Fantasia

---------------------------------------------------------------------------------------------------------------------
--Produtos Fracionados
---------------------------------------------------------------------------------------------------------------------

--Print 'Lista os Produtos Fracionados'

--Lista Apenas os Fracionados Caso @ic_tipo_produto = 1 ou 2

select 
  p.cd_produto                           as Codigo,
  p.nm_fantasia_produto                  as Fantasia,
  pf.cd_produto_fracionado,
  cast(case when px.nm_fantasia_produto is null 
       then isnull(p.nm_fantasia_produto,'') 
       else isnull(px.nm_fantasia_produto,'') 
  end as varchar(30) )                   as fantasiafracionado,
  isnull(te.cd_produto,0)                as cd_produto_embalagem,
  isnull(pf.qt_produto_fracionado,0)     as qt_produto_embalagem

into 
  #ProdutoFracionado

from 
  Produto p                            with (nolock) 
  inner join Produto_Fracionamento pf  with (nolock) on pf.cd_produto           = p.cd_produto
  left outer join Produto px           with (nolock) on px.cd_produto           = pf.cd_produto_fracionado
  left outer join Categoria_Produto cp with (nolock) on cp.cd_categoria_produto = p.cd_categoria_produto
  left outer join Tipo_Embalagem    te with (nolock) on te.cd_tipo_embalagem    = pf.cd_tipo_embalagem
where
  isnull(cp.ic_cpv_categoria,'N')='S' AND
  @ic_tipo_produto IN (1,2) 
	and isnull(p.cd_produto,0) = (CASE WHEN @cd_produto = 0 THEN    
                       					p.cd_produto       
                     				ELSE       
                       					@cd_produto       
                     				END)

 	AND (isnull(p.cd_grupo_produto,0) = CASE     
                            WHEN @cd_grupo_produto = 0 THEN       
                              isnull(p.cd_grupo_produto,0)    
                            ELSE       
                              @cd_grupo_produto    
                            END)   
     
 	AND (isnull(p.cd_categoria_produto,0) = CASE     
                            WHEN @cd_categoria_produto = 0 THEN       
                              isnull(p.cd_categoria_produto,0)       
                            ELSE       
                              @cd_categoria_produto    
                            END )                  
 	AND (ISNULL(p.ic_importacao_produto, 'N') = CASE     
                                              WHEN @ic_importacao_produto = 'T' THEN       
                                                ISNULL(p.ic_importacao_produto, 'N')       
                                              WHEN @ic_importacao_produto = 'S' THEN         
                                                @ic_importacao_produto    
                                              ELSE    
                                                @ic_importacao_produto    
                                              END)    
	and @ic_tipo_produto in (1,2)

order by
  p.cd_produto 

--select * from Produto_Fracionamento order by cd_produto_fracionado

--select * from #ProdutoFracionado order by Fantasia

--select * from tipo_embalagem

--Print 'Junção das Tabelas Produto'

insert into #AuxProduto 
  select * from #Produtofracionado


--select * from #AuxProduto order by Codigo

--select * from #AuxProduto order by fantasia

select 
  a.Codigo,
  a.Fantasia,
  a.cd_produto_fracionado,
  a.FantasiaFracionado,
  cd_produto           = case when isnull(a.cd_produto_fracionado,0) = 0 then a.Codigo               else a.cd_produto_fracionado end,
  cd_produto_embalagem = case when isnull(a.cd_produto_embalagem,0) <> 0 then a.cd_produto_embalagem else te.cd_produto end,
  qt_produto_embalagem = case when isnull(a.qt_produto_embalagem,0) <> 0 then a.qt_produto_embalagem else pf.qt_produto_fracionado end

into 
  #Produto  

from 
  #AuxProduto a
  left outer join Produto_Fracionamento pf on pf.cd_produto_fracionado = case when a.cd_produto_fracionado = 0 then a.codigo else a.cd_produto_fracionado end
                                              and pf.cd_produto           <> a.codigo

  left outer join Tipo_Embalagem        te on te.cd_tipo_embalagem     = pf.cd_tipo_embalagem
order by 
   a.Codigo

--select * from produto_fracionamento where cd_produto_fracionado = 757
--select * from produto where cd_produto = 546

--select * from #AuxProduto
--select * from #Produto order by fantasia

----------------------------------------------------------------------------------------
--Cálculo de Faturamento / Entrada do Produto
----------------------------------------------------------------------------------------
  
SELECT     
  p.cd_produto,    
  dbo.fn_mascara_produto(p.cd_produto)    as   cd_mascara_produto,     
  p.nm_fantasia_produto,    
  p.nm_produto,    
  um.sg_unidade_medida,    

--    
--- coluna quantidade total periodo faturada    
--    

  isnull((select     
                sum(    IsNull(nsi.qt_item_nota_saida,0)  )    
                from nota_saida_item nsi , nota_saida ns , operacao_fiscal ofi
                where nsi.cd_produto = p.cd_produto       
                   and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                   and nsi.dt_cancel_item_nota_saida is null     
                   and nsi.cd_nota_saida = ns.cd_nota_saida    
                   and ns.cd_tipo_destinatario = 1   
                   and ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal  
	           and ofi.ic_comercial_operacao = 'S' 
                 group by nsi.cd_produto),0)     as    'qt_total_periodo' ,     


--    
--Valor do Produto Unitário cd_moeda = 1 em reais  cd_moeda <> 1 Dolar     
--    

case when  @cd_moeda = 1 then     
                IsNull((select     
                sum(  ((IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)) -    
                       --IsNull(nsi.vl_ipi,0) -     
                       IsNull(nsi.vl_desp_acess_item,0) -    
                       IsNull(nsi.vl_icms_item,0) -    
                       IsNull(nsi.vl_desp_aduaneira_item,0) -    
                       IsNull(nsi.vl_ii,0) -    
                       ( case when IsNull(nsi.vl_pis,0)=0    then IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)*(1.65/100) else nsi.vl_pis    end ) -    
                       ( case when IsNull(nsi.vl_cofins,0)=0 then IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)*(7.6/100)  else nsi.vl_cofins end ))) /  sum(    IsNull(nsi.qt_item_nota_saida,0)  )    
                 from nota_saida_item nsi , nota_saida ns , operacao_fiscal ofi
                 where nsi.cd_produto = p.cd_produto     
                      and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                      and nsi.dt_cancel_item_nota_saida is null     
  		      and nsi.cd_nota_saida = ns.cd_nota_saida    
                      and ns.cd_tipo_destinatario = 1   
                      and ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal  
	              and ofi.ic_comercial_operacao = 'S' 
                 group by nsi.cd_produto),0)      
            else     
                IsNull((select     
                sum(  ((IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)) -    
--                       IsNull(nsi.vl_ipi,0) -     
                       IsNull(nsi.vl_desp_acess_item,0) -    
                       IsNull(nsi.vl_icms_item,0) -    
                       IsNull(nsi.vl_desp_aduaneira_item,0) -    
                       IsNull(nsi.vl_ii,0) -    
                       ( case when IsNull(nsi.vl_pis,0)=0    then IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)*(1.65/100) else nsi.vl_pis    end ) -    
                       ( case when IsNull(nsi.vl_cofins,0)=0 then IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)*(7.6/100)  else nsi.vl_cofins end ))/dbo.fn_vl_moeda_periodo(@cd_moeda,nsi.dt_nota_saida))   /    sum(    IsNull(nsi.qt_item_nota_saida,0)  )    
                 from nota_saida_item nsi , nota_saida ns , operacao_fiscal ofi
                 where nsi.cd_produto = p.cd_produto     
                      and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                      and nsi.dt_cancel_item_nota_saida is null     
  		      and nsi.cd_nota_saida         = ns.cd_nota_saida    
                      and ns.cd_tipo_destinatario   = 1   
                      and ns.cd_operacao_fiscal     = ofi.cd_operacao_fiscal  
	              and ofi.ic_comercial_operacao = 'S' 
                 group by nsi.cd_produto),0)      
    
            end    as 'vl_produto_unit',    

--Valor Unitário em R$

                IsNull((select     
                sum(  ((IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)) -    
                       IsNull(nsi.vl_ipi,0) -     
                       IsNull(nsi.vl_desp_acess_item,0) -    
                       IsNull(nsi.vl_icms_item,0) -    
                       IsNull(nsi.vl_desp_aduaneira_item,0) -    
                       IsNull(nsi.vl_ii,0) -    
                      ( case when IsNull(nsi.vl_pis,0)=0    then IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)*(1.65/100) else nsi.vl_pis    end ) -    
                      ( case when IsNull(nsi.vl_cofins,0)=0 then IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)*(7.6/100)  else nsi.vl_cofins end )  ) )
                      /    sum(    IsNull(nsi.qt_item_nota_saida,0)  )    
                 from nota_saida_item nsi , nota_saida ns , operacao_fiscal ofi
                 where nsi.cd_produto = p.cd_produto     
                      and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                      and nsi.dt_cancel_item_nota_saida is null     
  		      and nsi.cd_nota_saida = ns.cd_nota_saida    
                      and ns.cd_tipo_destinatario = 1   
                      and ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal  
	              and ofi.ic_comercial_operacao = 'S' 
                 group by nsi.cd_produto),0)  as vl_unitario,


--    
--Valor do Produto Total  cd_moeda = 1 em reais  cd_moeda <> 1 Dolar     
--    

case when  @cd_moeda = 1 then     
    IsNull((select     
                sum(  ((IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)) -    
                       IsNull(nsi.vl_ipi,0) -     
                       IsNull(nsi.vl_desp_acess_item,0) -    
                       IsNull(nsi.vl_icms_item,0) -    
                       IsNull(nsi.vl_desp_aduaneira_item,0) -    
                       IsNull(nsi.vl_ii,0) -    
                       ( case when IsNull(nsi.vl_pis,0)=0    then IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)*(1.65/100) else nsi.vl_pis    end ) -    
                       ( case when IsNull(nsi.vl_cofins,0)=0 then IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)*(7.6/100)  else nsi.vl_cofins end )  ) )    
                 from nota_saida_item nsi , nota_saida ns , operacao_fiscal ofi 
                 where nsi.cd_produto = p.cd_produto     
                      and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                      and nsi.dt_cancel_item_nota_saida is null     
                      and nsi.cd_nota_saida = ns.cd_nota_saida    
                      and ns.cd_tipo_destinatario = 1   
                      and ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal  
	              and ofi.ic_comercial_operacao = 'S' 
                 group by nsi.cd_produto),0)      
     else    
    IsNull((select     
                sum(  ((IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)) -    
                       IsNull(nsi.vl_ipi,0) -     
                       IsNull(nsi.vl_desp_acess_item,0) -    
                       IsNull(nsi.vl_icms_item,0) -    
                       IsNull(nsi.vl_desp_aduaneira_item,0) -    
                       IsNull(nsi.vl_ii,0) -    
                       ( case when IsNull(nsi.vl_pis,0)=0    then IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)*(1.65/100) else nsi.vl_pis    end ) -    
                       ( case when IsNull(nsi.vl_cofins,0)=0 then IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)*(7.6/100)  else nsi.vl_cofins end ))/dbo.fn_vl_moeda_periodo(@cd_moeda,nsi.dt_nota_saida) )    
                 from nota_saida_item nsi , nota_saida ns , operacao_fiscal ofi 
                 where nsi.cd_produto = p.cd_produto     
                      and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                      and nsi.dt_cancel_item_nota_saida is null     
                      and nsi.cd_nota_saida         = ns.cd_nota_saida    
                      and ns.cd_tipo_destinatario   = 1   
                      and ns.cd_operacao_fiscal     = ofi.cd_operacao_fiscal  
	              and ofi.ic_comercial_operacao = 'S' 
                 group by nsi.cd_produto),0)      
  end as 'vl_produtox',    

--Valor Total R$

    IsNull((select     
                sum(  ((IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)) -    
                       IsNull(nsi.vl_ipi,0) -     
                       IsNull(nsi.vl_desp_acess_item,0) -    
                       IsNull(nsi.vl_icms_item,0) -    
                       IsNull(nsi.vl_desp_aduaneira_item,0) -    
                       IsNull(nsi.vl_ii,0) -    
                       ( case when IsNull(nsi.vl_pis,0)=0    then IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)*(1.65/100) else nsi.vl_pis    end ) -    
                       ( case when IsNull(nsi.vl_cofins,0)=0 then IsNull(nsi.vl_unitario_item_nota,0) * IsNull(nsi.qt_item_nota_saida,0)*(7.6/100)  else nsi.vl_cofins end )  ) )    
                 from nota_saida_item nsi , nota_saida ns , operacao_fiscal ofi 
                 where nsi.cd_produto = p.cd_produto     
                      and nsi.dt_nota_saida between @dt_inicial and @dt_final     
                      and nsi.dt_cancel_item_nota_saida is null     
                      and nsi.cd_nota_saida = ns.cd_nota_saida    
                      and ns.cd_tipo_destinatario = 1   
                      and ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal  
	              and ofi.ic_comercial_operacao = 'S' 
                 group by nsi.cd_produto),0) as vl_total_calculado,     


  case when isnull(pf.cd_produto_fracionado,0)<> 0 then 'S'
                                                   else 'N' end as Fracionado,

   (Select pp.nm_fantasia_produto from Produto pp where pp.cd_produto = case when isnull(pf.cd_produto_fracionado,0)<> 0 then isnull(pf.cd_produto,0) else isnull(p.cd_produto,0) end) as Principal,
	
  isnull(cp.pc_cpv_categoria ,0)  as pc_cpv_categoria,

  --Custo de Reposição Direto do Cadastro do Produto ( Tabela_Produto_Custo )
  isnull(pc.vl_custo_produto,0)   as CustoReposicao,

--Busca o Custo de Entrada da Última Nota fiscal de Entrada ( Nota_Entrada_item )
  --select * from nota_entrada_item

  isnull((select top 1 IsNull(nei.pc_icms_nota_entrada,18)     
          from nota_entrada_item nei     with (nolock)         
          inner join nota_entrada ne     with (nolock) on ne.cd_nota_entrada      = nei.cd_nota_entrada    and
                                                          ne.cd_fornecedor        = nei.cd_fornecedor      and
                                                          ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
                                                          ne.cd_operacao_fiscal   = nei.cd_operacao_fiscal 
          inner join operacao_fiscal opf with (nolock) on opf.cd_operacao_fiscal  =  ne.cd_operacao_fiscal 
          where nei.cd_produto                           = p.cd_produto
                and isnull(opf.ic_comercial_operacao,'N')='S'
                and nei.dt_item_receb_nota_entrad <= @dt_final
 
          order by nei.dt_item_receb_nota_entrad desc ),18)    as aliquotaICMSEntrada,

  --select * from nota_entrada_item

  isnull((select top 1 IsNull(nei.pc_ipi_nota_entrada,18)     
          from nota_entrada_item nei     with (nolock)         
          inner join nota_entrada ne     with (nolock) on ne.cd_nota_entrada      = nei.cd_nota_entrada    and
                                                          ne.cd_fornecedor        = nei.cd_fornecedor      and
                                                          ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
                                                          ne.cd_operacao_fiscal   = nei.cd_operacao_fiscal 
          inner join operacao_fiscal opf with (nolock) on opf.cd_operacao_fiscal  =  ne.cd_operacao_fiscal 
          where nei.cd_produto                           = p.cd_produto
                and isnull(opf.ic_comercial_operacao,'N')='S'
                and nei.dt_item_receb_nota_entrad <= @dt_final
 
          order by nei.dt_item_receb_nota_entrad desc ),18)    as aliquotaIPIEntrada,

  isnull((select top 1 IsNull(nei.vl_item_nota_entrada,0)     
          from nota_entrada_item nei with (nolock)              
          inner join nota_entrada ne on ne.cd_nota_entrada         = nei.cd_nota_entrada      and
                                        ne.cd_fornecedor           = nei.cd_fornecedor        and
                                        ne.cd_serie_nota_fiscal    = nei.cd_serie_nota_fiscal and
                                        ne.cd_operacao_fiscal      = nei.cd_operacao_fiscal 
          inner join operacao_fiscal opf on opf.cd_operacao_fiscal =  ne.cd_operacao_fiscal 
          where nei.cd_produto = p.cd_produto
                and isnull(opf.ic_comercial_operacao,'N')='S'
                and nei.dt_item_receb_nota_entrad <= @dt_final

          order by nei.dt_item_receb_nota_entrad desc ),0)     as CustoEntrada,


--Data da Última Entrada do Produto p/ Conversão na Moeda

  isnull((select max(IsNull(nei.dt_item_receb_nota_entrad,0))     
          from nota_entrada_item nei    
          inner join nota_entrada ne on ne.cd_nota_entrada      = nei.cd_nota_entrada      and
                                        ne.cd_fornecedor        = nei.cd_fornecedor        and
                                        ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
                                        ne.cd_operacao_fiscal   = nei.cd_operacao_fiscal 
          inner join operacao_fiscal opf on opf.cd_operacao_fiscal =  ne.cd_operacao_fiscal 
          where nei.cd_produto = p.cd_produto  and isnull(opf.ic_comercial_operacao,'N')='S'
                              and nei.dt_item_receb_nota_entrad <= @dt_final ),0) as 'DataCusto',

  cp.nm_categoria_produto,

  isnull(p.vl_fator_conversao_produt,0)                                           as  vl_fator_conversao_produt

--  p.ic_importacao_produto     

--select * from nota_entrada_item
--select * from produto_fiscal

Into    
 #TmpCpvEspecial    

FROM     
  Produto p                                 with (nolock) 
  LEFT OUTER JOIN  Unidade_Medida um        with (nolock) on p.cd_unidade_medida      = um.cd_unidade_medida    
  LEFT OUTER JOIN  Produto_Custo pc         with (nolock) on p.cd_produto             = pc.cd_produto    
  LEFT OUTER JOIN  Produto_Fracionamento pf with (nolock) on pf.cd_produto_fracionado = p.cd_produto
  LEFT OUTER JOIN  Categoria_produto cp     with (nolock) on cp.cd_categoria_produto  = p.cd_categoria_produto
  
WHERE    
	--Produ ou FRacionados depende do parametro @ic_tipo_produto
   (isnull(p.cd_produto,0) = (CASE WHEN @cd_produto = 0 THEN    
                       					p.cd_produto       
                     				ELSE       
                       					@cd_produto       
                     				END)
	or isnull(p.cd_produto,0) in (select cd_produto from #produto)
 )
    
 AND isnull(p.cd_grupo_produto,0) = CASE     
                            WHEN @cd_grupo_produto = 0 THEN       
                              isnull(p.cd_grupo_produto,0)    
                            ELSE       
                              @cd_grupo_produto    
                            END    
     
 AND isnull(p.cd_categoria_produto,0) = CASE     
                            WHEN @cd_categoria_produto = 0 THEN       
                              isnull(p.cd_categoria_produto,0)       
                            ELSE       
                              @cd_categoria_produto    
                            END    
     
-- AND isnull(p.cd_categoria_produto, 0) <> 6     
    
  
 AND isnull(p.cd_STATUS_produto, 0) <> 2  
    
    
    
 AND ISNULL(p.ic_importacao_produto, 'N') = CASE     
                                              WHEN @ic_importacao_produto = 'T' THEN       
                                                ISNULL(p.ic_importacao_produto, 'N')       
                                              WHEN @ic_importacao_produto = 'S' THEN         
                                                @ic_importacao_produto    
                                              ELSE    
                                                @ic_importacao_produto    
                                              END    

--select * from  #TmpCpvEspecial    


Select 
  	p.codigo,
  	c.*,

  --Dedução dos Impostos--------------------------------------------------------------------------------------------------------------

  Custo = dbo.fn_vl_liquido_custo ('F',case when  @cd_moeda = 1 then 
                                     case when CustoEntrada>0 then CustoEntrada else CustoReposicao end
                                   else 
                                     case when CustoEntrada>0 then CustoEntrada   / ( case when dbo.fn_vl_moeda_periodo(@cd_moeda,c.DataCusto)=0 then 1 else dbo.fn_vl_moeda_periodo(@cd_moeda,c.DataCusto) end ) 
                                                              else CustoReposicao / ( case when dbo.fn_vl_moeda_periodo(@cd_moeda,c.DataCusto)=0 then 1 else dbo.fn_vl_moeda_periodo(@cd_moeda,c.DataCusto) end ) end
           end,aliquotaICMSEntrada,aliquotaIPIEntrada,0,@dt_inicial,'S','N'),    

  isnull( (select isnull(vl_custo_produto,0) from Produto_Custo with (nolock) 
           where 
              cd_produto = p.cd_produto_embalagem),0)                            as 'CustoEmbalagemReposicao',

  --Custo Direto da Nota Fiscal de Entrada - ( Temos que tirar o ICMS )----------------------------------------------------------------

  dbo.fn_vl_liquido_custo('F',IsNull((select top 1(IsNull(nei.vl_item_nota_entrada,0))     
          from nota_entrada_item nei  with (nolock)   
          inner join nota_entrada ne  with (nolock) on ne.cd_nota_entrada        = nei.cd_nota_entrada and
                                                       ne.cd_fornecedor          = nei.cd_fornecedor      and
                                                       ne.cd_serie_nota_fiscal   = nei.cd_serie_nota_fiscal and
                                                       ne.cd_operacao_fiscal     = nei.cd_operacao_fiscal    
          inner join operacao_fiscal opf with (nolock) on opf.cd_operacao_fiscal =  ne.cd_operacao_fiscal 
          where 
              nei.cd_produto = p.cd_produto_embalagem and 
              isnull(opf.ic_comercial_operacao,'N')='S'
              and nei.dt_item_receb_nota_entrad <= @dt_final

          order by 
              nei.dt_item_receb_nota_entrad desc),0),
          IsNull((select top 1 (IsNull(nei.pc_icms_nota_entrada,18))     
          from nota_entrada_item nei    
          inner join nota_entrada ne on ne.cd_nota_entrada         = nei.cd_nota_entrada and
                                        ne.cd_fornecedor           = nei.cd_fornecedor      and
                                        ne.cd_serie_nota_fiscal    = nei.cd_serie_nota_fiscal and
                                        ne.cd_operacao_fiscal      = nei.cd_operacao_fiscal    
          inner join operacao_fiscal opf on opf.cd_operacao_fiscal =  ne.cd_operacao_fiscal 
          where nei.cd_produto = p.cd_produto_embalagem 
                and isnull(opf.ic_comercial_operacao,'N')='S'
              and nei.dt_item_receb_nota_entrad <= @dt_final
          order by 
                nei.dt_item_receb_nota_entrad desc),18),0,0,@dt_inicial,'S','N') as 'CustoEmbalagem',

  --isnull( (select vl_custo_produto from Produto_Custo where cd_produto = p.cd_produto_embalagem),0) as 'CustoEmbalagem',
                       
  p.qt_produto_embalagem,
  p.cd_produto_embalagem

into #CPV 
from 
  #Produto p 
  inner join #TmpCpvEspecial c on p.cd_produto = c.cd_produto

order by 
  p.codigo

--select * from #CPV order by nm_fantasia_produto

------------------------------------------------------------------------------------------------
--Cálculo das Despesas
------------------------------------------------------------------------------------------------

exec pr_movimento_financeiro_categoria 1,0,@dt_inicial,@dt_final,2  --Despesas Realizadas

declare @vl_despesa_frete    float
declare @vl_despesa_comissao float
declare @vl_despesa_producao float
declare @vl_despesa_adm      float
declare @qt_produto          float

--Quantidade Geral para Rateio das Despesas

select
  @qt_produto = sum( isnull(qt_total_periodo,0) )
from
  #CPV

if @qt_produto = 0 
begin
  set @qt_produto = 1
end

--Frete

select
  @vl_despesa_frete = isnull(vl_categoria_financeiro,0)  
from
  Categoria_Financeiro with (nolock) 
where
  cd_categoria_financeiro = 1 

--Comissão

select
  @vl_despesa_comissao = isnull(vl_categoria_financeiro,0)  
from
  Categoria_Financeiro with (nolock) 
where
  cd_categoria_financeiro = 2

--Despesas de Produção

select
  @vl_despesa_producao = isnull(vl_categoria_financeiro,0)  
from
  Categoria_Financeiro with (nolock) 
where
  cd_categoria_financeiro = 3

--Despesas Administrativa

select
  @vl_despesa_adm = isnull(vl_categoria_financeiro,0)  
from
  Categoria_Financeiro with (nolock) 
where
  cd_categoria_financeiro = 4


--select @vl_despesa_adm


------------------------------------------------------------------------------------------------
--Tabela Final ou será agrupada ou visualizada como está
------------------------------------------------------------------------------------------------

  select
    *,
   (qt_total_periodo/@qt_produto)*(pc_cpv_categoria/100)*@vl_despesa_frete             as Frete,
    CustoTotal = Custo * qt_total_periodo,
    Margem     = ((Custo*qt_total_periodo)/(case when vl_produtox>0 then (round(vl_produto_unit,2) * qt_total_periodo) else 1 end ))*100,
    case when CustoEmbalagem>0 then CustoEmbalagem else CustoEmbalagemReposicao end     as CustoEmbalagemTotal,
   (case when CustoEmbalagem>0 then CustoEmbalagem else CustoEmbalagemReposicao end )
                 * qt_total_periodo     
                                                                                       as Embalagem,
   (qt_total_periodo/@qt_produto)*(pc_cpv_categoria/100)*@vl_despesa_comissao          as Comissao,

    --Verifica se o Produto é Fracionado

   case when fracionado = 'S' then 
     (qt_total_periodo/@qt_produto)*(pc_cpv_categoria/100)*@vl_despesa_producao else 0 end  as MaoObra,

     (qt_total_periodo/@qt_produto)*(pc_cpv_categoria/100)*@vl_despesa_adm                  as DespesasAdm,

   vl_produto = round(vl_produto_unit,2) * qt_total_periodo,

   case when fracionado = 'S' 
   then
     qt_total_periodo  * vl_fator_conversao_produt
   else
     (qt_total_periodo * vl_fator_conversao_produt)-qt_total_periodo
   end                               as qt_convertida,

   case when fracionado = 'S' 
   then 0.00 
   else      
    qt_total_periodo 
   end                               as qt_original,   

   --Calculo do (%)s Embalagem / Frete / Mão-Obra / Despesas Administrativas 

   pEmbalagem = ( (case when CustoEmbalagem>0 then CustoEmbalagem else CustoEmbalagemReposicao end ) * qt_total_periodo     
                  / (round(vl_produto_unit,2) * qt_total_periodo) * 100 ),

   pFrete     = (((qt_total_periodo/@qt_produto)*(pc_cpv_categoria/100)*@vl_despesa_frete)/ (round(vl_produto_unit,2) * qt_total_periodo) * 100 ),

   pMaoObra   = ((case when fracionado = 'S' then 
                  (qt_total_periodo/@qt_produto)*(pc_cpv_categoria/100)*@vl_despesa_producao else 0 end ) 
                  / (round(vl_produto_unit,2) * qt_total_periodo) * 100 ),
 

 
   pDespesa   = (((qt_total_periodo/@qt_produto)*(pc_cpv_categoria/100)*@vl_despesa_adm)                  
                 / (round(vl_produto_unit,2) * qt_total_periodo) * 100 ),

   pComissao  = (((qt_total_periodo/@qt_produto)*(pc_cpv_categoria/100)*@vl_despesa_comissao) / (round(vl_produto_unit,2) * qt_total_periodo) * 100 )

   into #CPVFinal
   from 
    #CPV

   where
      isnull(cd_produto,0) in (select  cd_produto from #Produto 
   			 where #Produto.cd_produto = (	
																			case  
																			when @ic_tipo_produto = 2 then 
																				(case when #Produto.Codigo <> #Produto.cd_produto then 
																						#Produto.cd_produto
																				else
																					0
                                                            end) 
 																			when @ic_tipo_produto = 1 then
 																				#Produto.cd_produto
																			else 
																				#Produto.codigo 
																			end) 
										)
    and 1 = 	(Case 
					when @ic_consulta_mov_venda = 'N'then
						(case when qt_total_periodo > 0 then 1 else 0 end)	
					else 
						1
					end)							     	

   order by 
     codigo

--select codigo,* from #CPVFinal order by nm_fantasia_produto
--select codigo,* from #CPVFinal order by codigo

------------------------------------------------------------------------------------------------
--Zera o Custo do produto Fracionado
------------------------------------------------------------------------------------------------

update
  produto_custo
set
  vl_custo_fracionado_produto = 0

------------------------------------------------------------------------------------------------
--Atualização do Custo do produto Fracionado
------------------------------------------------------------------------------------------------
update
  produto_custo
set
  vl_custo_fracionado_produto = isnull(c.Custo,0) + isnull(c.CustoEmbalagem,0),
  vl_custo_contabil_produto   = isnull(c.Custo,0)
from
  Produto_Custo pc
  inner join #CPVFinal c on c.codigo = pc.cd_produto

--Select * from #CPVFinal


------------------------------------------------------------------------------------------------
--Apresentação da Tabela
------------------------------------------------------------------------------------------------

--Produto Calculado ou Produtos Fracionados

if @ic_tipo_produto = 0 or @ic_tipo_produto = 2 
begin
  Select 
    distinct
    *
  from
    #CPVFinal 
  where 
    codigo = (case when  IsNull(@cd_produto_original,0) = 0  then codigo else
					   IsNull(@cd_produto_original,0) end ) 
end
else 

--Produtos Originais

if @ic_tipo_produto = 1
begin

-- declare @vl_custo_total decimal(25,2)
-- set @vl_custo_total = 0
-- 
-- select
--   @vl_custo_total = sum(c.CustoTotal)
-- from 
--   #CPVFinal C

	Select 
          DISTINCT
		Codigo, 
                Codigo                           as cd_produto,
		p.cd_mascara_produto,
		p.nm_fantasia_produto,
		p.nm_produto,
		u.sg_unidade_medida,
                Sum(c.qt_total_periodo)                        as qt_total_periodo_original,
		Sum(c.qt_total_periodo*c.qt_produto_embalagem) as qt_total_periodo,  
		Sum(c.vl_produto)/
                Sum(c.qt_total_periodo*
                    c.qt_produto_embalagem)                    as vl_produto_unit,

		Sum(c.vl_unitario)                             as vl_unitario,
		Sum(c.vl_produtox)                             as vl_produtox,
		Sum(c.vl_total_calculado)                      as vl_total_calculado, 
		Fracionado = 'N',
 		Sum(c.pc_cpv_categoria)                        as pc_cpv_categoria,
 		Sum(c.CustoReposicao)                          as CustoReposicao,
 		Max(c.aliquotaICMSEntrada)                     as aliquotaICMSEntrada,
 		Sum(isnull(c.CustoEntrada,0))                  as CustoEntrada,
 		Null                                           as DataCusto,
		cp.nm_categoria_produto,
 		Sum(c.qt_produto_embalagem)                    as vl_fator_conversao_produt,
		p.nm_fantasia_produto                          as Principal,                           

 		(Sum(c.CustoTotal)/
                Sum(c.qt_total_periodo*c.qt_produto_embalagem)) as Custo,

-- 		(Sum(c.CustoTotal)/Sum(c.qt_total_periodo))      as Custo,

		Sum(c.CustoEmbalagemReposicao)                  as CustoEmbalagemReposicao,
		Sum(c.CustoEmbalagem)                           as CustoEmbalagem,
		Sum(c.qt_produto_embalagem)                     as qt_produto_embalagem,
		Codigo                                          as cd_produto_embalagem,
		Sum(c.CustoTotal)                               as CustoTotal,
		(sum(c.CustoTotal)/sum(c.vl_produto) ) * 100    as Margem,
		Sum(c.CustoEmbalagemTotal)                      as CustoEmbalagemTotal,
		Sum(c.Embalagem)                                as Embalagem,
		Sum(c.Frete)                                    as Frete,
		Sum(c.Comissao)                                 as Comissao,
		Sum(c.MaoObra)                                  as MaoObra,
		Sum(c.DespesasAdm)                              as DespesasAdm,
		Sum(c.vl_produto)                               as vl_produto,
                Sum(c.qt_convertida)                                    as qt_convertida,
                (Sum(isnull(c.Embalagem,0)) /Sum(c.vl_produto))*100     as pEmbalagem,
                (Sum(isnull(c.Frete,0))     /Sum(c.vl_produto))*100     as pFrete,
                (Sum(isnull(c.MaoObra,0))   /Sum(c.vl_produto))*100     as pMaoObra,
                (Sum(isnull(c.DespesasAdm,0))/Sum(c.vl_produto))*100    as pDespesa,
                (Sum(isnull(c.Comissao,0))  /Sum(c.vl_produto))*100     as pComissao,
                Sum(c.qt_original)                                      as qt_original 

        from #CPVFinal C left join 
	     Produto P            on P.cd_produto = c.codigo left join		  	
             Unidade_Medida u     on u.cd_unidade_medida = p.cd_unidade_medida left join
             Categoria_produto cp on cp.cd_categoria_produto  = p.cd_categoria_produto
        where
            c.cd_produto = case when @cd_produto = 0 then c.cd_produto else @cd_produto end
	group by
	   c.Codigo,
           p.cd_mascara_produto,
           p.nm_fantasia_produto,
           p.nm_produto,
           u.sg_unidade_medida,
           cp.nm_categoria_produto

end

---------------------------------------------------------------------------------------------------------------------


