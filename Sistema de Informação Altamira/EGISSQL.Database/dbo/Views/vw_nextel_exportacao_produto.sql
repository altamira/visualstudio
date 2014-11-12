
CREATE VIEW vw_nextel_exportacao_produto
	------------------------------------------------------------------------------------
	--vw_nextel_exportacao_produto
	------------------------------------------------------------------------------------
	--GBS - Global Business Solution	                                       2008
	------------------------------------------------------------------------------------
	--Stored Procedure	: Microsoft SQL Server 2000
	--Autor(es)             : Douglas de Paula Lopes
	--Banco de Dados	: EGISSQL
	--Objetivo	        : Remessa nextel produto.
	--Data                  : 22/07/2008  
	--Atualização           : 19.11.2008 - Ajuste do Flag para exportação do Produto - Carlos Fernandes
	--01.04.2009 - Somente produto Comercial - Carlos Fernandes                        
	--07.04.2009 - Produto Ativos - Carlos Fernandes
	--13.04.2009 - Verificação da quantidade do estoque - Carlos Fernandes
	--14.04.2009 - Soma de Todas as Fase de Produto e conversão da quantidade - Carlos Fernandes
        --22.04.2009 - Custo de Produto / Custo de Mercado - Carlos Fernandes
	----------------------------------------------------------------------------------------------------
	as
	
	--select * from produto_saldo
	--select * from fase_produto
	
	select
	
	  --Linha Única Separada por Pipe
	
	  cast(isnull(dbo.fn_strzero(p.cd_mascara_produto,4),'') as varchar(4)) + '|' +
	
	  cast(p.nm_produto as char(43))                             + '|' +
	
	  cast(dbo.fn_strzero(cast(isnull(p.qt_multiplo_embalagem,0) as int),2)     as varchar(2)) + '|' +
	
	  --Soma de Todas as Fase de Produto
	
	  cast( 
	
	  dbo.fn_strzero( 
	
	  
	  cast( 
	
	  (	
	  isnull((select
	    sum(
	 
	    case when isnull(psx.qt_saldo_reserva_produto,0)<=0 then 0 else isnull(psx.qt_saldo_reserva_produto,0) end
	
	    *
	
	    case when isnull(fpx.ic_conversao_multiplo,'N')='N' 
	    then
	       1
	    else
	      case when isnull(px.qt_multiplo_embalagem,0)>0 
	      then
	        isnull(px.qt_multiplo_embalagem,0)
	      else
	        1
	      end                                                            
	    end)  
	   from
	     Produto_Saldo psx            with (nolock) 
	     inner join Fase_Produto fpx  with (nolock) on fpx.cd_fase_produto = psx.cd_fase_produto
	     inner join Produto      px   with (nolock) on px.cd_produto       = psx.cd_produto 
	   where
	    isnull(psx.qt_saldo_reserva_produto,0)>0 and
	    psx.cd_produto = p.cd_produto
	   group by
	     psx.cd_produto ),0) 
           )  as int),8) as varchar(8)) + '|' +
	

          ---------------------------------------------------------------------------------------------
          --Preços dos Produtos
          ---------------------------------------------------------------------------------------------
 
	  replace( cast( str( isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 1),0),10,2) as varchar(12) ), '.', ',')                         + '|' +
	
	  replace( cast(str(isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 2),0),10,2) as varchar(12)), '.', ',')                          + '|' +
	
	  replace( cast(str(isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 3),0),10,2) as varchar(12)), '.', ',')                                     + '|' +
	
	  replace( cast(str(isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 4),0),10,2) as varchar(12)), '.', ',')                                     + '|' +
	
	  replace( cast(str(isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 5),0),10,2) as varchar(12)), '.', ',')                                     + '|' +
	
	  replace( cast(str(isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 6),0),10,2) as varchar(12)), '.', ',')                                     + '|' +
	
	  replace( cast(str(isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 7),0),10,2) as varchar(12)), '.', ',')                                     + '|' +
	
	  replace( cast(str(isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 8),0),10,2) as varchar(12)), '.', ',')                                     + '|' +
	
	  replace( cast(str(isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 9),0),10,2) as varchar(12)), '.', ',')                                     + '|' +
	
	    replace( cast(str(isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 10),0),10,2) as varchar(12)), '.', ',')                                     
	
	                                                                                        as Linha,
	
	  cast(str(p.cd_mascara_produto,4) as varchar(4))                                       as COD, 
	
	  cast(p.nm_produto as char(43))                                                        as DESCR,
	
	  cast(dbo.fn_strzero(cast(isnull(p.qt_multiplo_embalagem,0) as int),2) as varchar(2))  as QTDEMB,
	
	--  cast(te.qt_cd_tipo_embalagem as int(8))  as QTDEMB,
	
-- 	  (select
-- 	    sum(
-- 	 
-- 	    isnull(psx.qt_saldo_reserva_produto,0)  
-- 	
-- 	    *
-- 	
-- 	    case when isnull(fpx.ic_conversao_multiplo,'N')='N' 
-- 	    then
-- 	       1
-- 	    else
-- 	      case when isnull(px.qt_multiplo_embalagem,0)>0 
-- 	      then
-- 	        isnull(px.qt_multiplo_embalagem,0)
-- 	      else
-- 	        1
-- 	      end                                                            
-- 	    end)  
-- 	   from
-- 	     Produto_Saldo psx            with (nolock) 
-- 	     inner join Fase_Produto fpx  with (nolock) on fpx.cd_fase_produto = psx.cd_fase_produto
-- 	     inner join Produto      px   with (nolock) on px.cd_produto       = psx.cd_produto 
--              
-- 	   where
-- 	    isnull(psx.qt_saldo_reserva_produto,0)>0 and
-- 	    psx.cd_produto = p.cd_produto
-- 	   group by
-- 	     psx.cd_produto )                                                                              as Estoque,
	
	
	--  cast(dbo.fn_strzero(cast(isnull(ps.qt_saldo_reserva_produto,0) as int),8) as varchar(8))     as ESTOQUE, --Saldo Disponível para Venda
	
	  --isnull(p.vl_produto,0)                     as PRTB1,
	
	  isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp  with (nolock) 
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 1),0)                           as PRTB1,
	
	  isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp with (nolock) 
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 2),0)                           as PRTB2,
	
	  isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 3),0)                           as PRTB3,
	
	  isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 4),0)                           as PRTB4,
	
	  isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 5),0)                           as PRTB5,
	
	  isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 6),0)                           as PRTB6,
	
	  isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto        = p.cd_produto and
	        tp.cd_tabela_preco  = 7),0)                           as PRTB7,
	
	  isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto       = p.cd_produto and
	        tp.cd_tabela_preco  = 8),0)                           as PRTB8,
	
	  isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto = p.cd_produto and
	        tp.cd_tabela_preco  = 9),0)                           as PRTB9,
	
	  isnull( 
	    ( select top 1 vl_tabela_produto
	      from
	        Tabela_preco_produto tp
	      where
	        tp.cd_produto = p.cd_produto and
	        tp.cd_tabela_preco  = 10),0)                           as PRTB10,

        p.cd_mascara_produto,
        p.nm_produto,
        um.sg_unidade_medida, 
        p.qt_multiplo_embalagem,
      
	  (select
	    sum(
	 
	    isnull(psx.qt_saldo_reserva_produto,0)  
	
	    *
	
	    case when isnull(fpx.ic_conversao_multiplo,'N')='N' 
	    then
	       1
	    else
	      case when isnull(px.qt_multiplo_embalagem,0)>0 
	      then
	        isnull(px.qt_multiplo_embalagem,0)
	      else
	        1
	      end                                                            
	    end)  
	   from
	     Produto_Saldo psx            with (nolock) 
	     inner join Fase_Produto fpx  with (nolock) on fpx.cd_fase_produto = psx.cd_fase_produto
	     inner join Produto      px   with (nolock) on px.cd_produto       = psx.cd_produto 
             
	   where
	    isnull(psx.qt_saldo_reserva_produto,0)>0 and
	    psx.cd_produto = p.cd_produto
	   group by
	     psx.cd_produto )                                                                              as Estoque,

        --Custo Previsto
        cast(round(isnull(pc.vl_custo_previsto_produto,0),2)  as decimal(25,2))                        as vl_custo_previsto_produto,
        
        cast(round(isnull(  pc.vl_custo_previsto_produto,0) 

          * 

	  (select
	    sum(
	 
	    isnull(psx.qt_saldo_reserva_produto,0)  
	
	    *
	
	    case when isnull(fpx.ic_conversao_multiplo,'N')='N' 
	    then
	       1
	    else
               1
-- 	      case when isnull(px.qt_multiplo_embalagem,0)>0 
-- 	      then
-- 	        isnull(px.qt_multiplo_embalagem,0)
-- 	      else
-- 	        1
-- 	      end                                                            
	    end)  
	   from
	     Produto_Saldo psx            with (nolock) 
	     inner join Fase_Produto fpx  with (nolock) on fpx.cd_fase_produto = psx.cd_fase_produto
	     inner join Produto      px   with (nolock) on px.cd_produto       = psx.cd_produto 
             
	   where
	    isnull(psx.qt_saldo_reserva_produto,0)>0 and
	    psx.cd_produto = p.cd_produto
	   group by
	     psx.cd_produto ),2) as decimal(25,2))                                     as Custo_Estoque
	

      
        --select * from produto_custo
	
	--   '' as PRTB2,
	--   '' as PRTB3,
	--   '' as PRTB4,
	--   '' as PRTB5,
	--   '' as PRTB6,
	--   '' as PRTB7,
	--   '' as PRTB8,
	--   '' as PRTB9,
	--   '' as PRTB10
	
	from
	  produto                        p  with(nolock)
	  left outer join produto_saldo  ps with(nolock) on ps.cd_produto        = p.cd_produto                      and
	                                                    ps.cd_fase_produto   = isnull(p.cd_fase_produto_baixa,0)
	 
	  left outer join tipo_embalagem te with(nolock) on te.cd_tipo_embalagem = p. cd_tipo_embalagem
	  left outer join produto_custo  pc with(nolock) on pc.cd_produto        = p.cd_produto
	  left outer join status_produto sp with(nolock) on sp.cd_status_produto = p.cd_status_produto
	  left outer join Tabela_Preco_Produto tpp with (nolock) on tpp.cd_tabela_preco = 1 and
	                                                            tpp.cd_produto      = p.cd_produto
	
	  left outer join Fase_Produto   fp        with (nolock) on fp.cd_fase_produto = ps.cd_fase_produto
          left outer join Unidade_Medida um        with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
	where
	  isnull(pc.ic_lista_preco_produto,'N') = 'S' and
	  isnull(p.ic_comercial_produto,'N')    = 'S' and
	  isnull(sp.ic_permitir_venda,'N')      = 'S' and
	  isnull(sp.ic_bloqueia_uso_produto,'N')= 'N' 

	  --Somente os produto com Saldo de Estoque  
	
	  --and isnull(ps.qt_saldo_reserva_produto,0)>=0    
	
	  --Somente enviar para o Rádio produto com Preço na Lista Zero 
	
	  and isnull(tpp.vl_tabela_produto,0)>0
	
	  ---------------------------------------------------------------------------------------------------
	
	-- select
	--   ps.cd_produto,
	--   sum(
	--  
	--   isnull(ps.qt_saldo_reserva_produto,0) 
	-- 
	--   *
	-- 
	--   case when isnull(fp.ic_conversao_multiplo,'N')='N' 
	--   then
	--      1
	--   else
	--     case when isnull(p.qt_multiplo_embalagem,0)>0 
	--     then
	--       isnull(p.qt_multiplo_embalagem,0)
	--     else
	--       1
	--     end                                                            
	--   end
	--   )
	-- from
	--   Produto_Saldo ps            with (nolock) 
	--   inner join Fase_Produto fp  with (nolock) on fp.cd_fase_produto = ps.cd_fase_produto
	--   inner join Produto      p   with (nolock) on p.cd_produto       = ps.cd_produto 
	-- where
	--   isnull(ps.qt_saldo_reserva_produto,0)>0
	-- group by
	--   ps.cd_produto
	
	--select * from status_produto
	--select * from produto_custo
	--select * from tabela_preco_produto
	
	
	