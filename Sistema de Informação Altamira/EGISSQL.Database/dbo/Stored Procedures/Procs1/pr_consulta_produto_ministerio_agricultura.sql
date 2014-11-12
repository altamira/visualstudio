
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_produto_ministerio_agricultura
-------------------------------------------------------------------------------
--pr_consulta_produto_ministerio_agricultura
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 03.10.2009
--Alteração        : 
--
-- 28.12.2009 - Finalização do Desenvolvimento - Carlos Fernandes
-- 06.04.2010 - Ajustes Diversos - Carlos Fernandes
-- 16.04.2010 - Ajustes/Complemento - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_produto_ministerio_agricultura
@cd_fase_produto   int      = 0,
--@cd_produto       int      = 0,
@dt_inicial        datetime = 0,
@dt_final          datetime = '',
@dt_inicio_estoque datetime = ''
as

 set @cd_fase_produto   = 3  

-- set @dt_inicio_estoque = '2009-09-30 00:00:00.000'  
-- set @dt_inicial        = '10/01/2009'
-- set @dt_final          = '12/31/2009'
  


--select @cd_fase_produto,@dt_inicial,@dt_final  
  
--select * from fase_produto  
--select * from produto_fechamento  
  
--Estoque Inicial no Período  
  
select  
  pf.cd_produto,  
  isnull(pf.qt_atual_prod_fechamento,0) as qt_inicial  

into  
  #EstoqueInicial  
  
from  
  produto_fechamento pf with (nolock)   
  
where  
  cd_fase_produto       = @cd_fase_produto and  
  dt_produto_fechamento = @dt_inicio_estoque  
  
  
--Estoque Final no Período  
  
  
select  
  pf.cd_produto,  
  isnull(pf.qt_atual_prod_fechamento,0) as qt_final  
into  
  #EstoqueFinal  
  
from  
  produto_fechamento pf with (nolock)   
  
where  
  cd_fase_produto       = @cd_fase_produto and  
  dt_produto_fechamento = @dt_final  
  

--Verifica se houve exportação no Período 
--select * from vw_faturamento

select
  i.cd_produto,
  max(i.nm_pais) as nm_pais_exportacao

into
  #PaisExportacao

from  
  vw_faturamento i                          with (nolock)   
  inner join nota_saida n                   with (nolock) on n.cd_nota_saida              = i.cd_nota_saida  
  left outer join operacao_fiscal opf       with (nolock) on opf.cd_operacao_fiscal       = n.cd_operacao_fiscal  
  left outer join grupo_operacao_fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal  

 where  
   n.cd_status_nota = 5                                
   and n.dt_nota_saida between @dt_inicial and @dt_final   
   and n.dt_cancel_nota_saida is null                      
   and gof.cd_tipo_operacao_fiscal = 2                    --SAIDAS  
   and gof.ic_procedencia_op_fiscal = 'I'                    --FORA DO ESTADO  
   and gof.ic_estado_grupo_op_fiscal = 'S'   
--   and isnull(opf.ic_comercial_operacao,'N')='S'                   --COMERCIAL  
     and isnull(opf.ic_estoque_op_fiscal,'N') ='S'
     and isnull(gof.cd_digito_grupo,0) = 7             --Exportação
  
group by
   i.cd_produto

--select * from produto_fechamento where cd_produto = 187  

--Movimento de Ajuste do Estoque-----------------------------------------------------------
--select * from movimento_estoque
--select * from tipo_documento_estoque

select
  m.cd_produto,  
  sum( isnull(m.qt_movimento_estoque,0) ) as qt_movimento
into  
  #Movimento  
  
from  
  movimento_estoque m                         with (nolock)   
  
where  
  m.dt_movimento_estoque between @dt_inicial and @dt_final and  
  m.ic_mov_movimento          ='S'                         and
  m.cd_tipo_documento_estoque = 1  

group by  
  m.cd_produto  

--select * from tipo_movimento_estoque  
  
--Importação  
  
select  
  i.cd_produto,  
  sum( isnull(i.qt_item_nota_saida,0) ) as qt_importacao  
into  
  #Importacao  
  
from  
  nota_saida_item i                         with (nolock)   
  inner join nota_saida n                   with (nolock) on n.cd_nota_saida              = i.cd_nota_saida  
  left outer join operacao_fiscal opf       with (nolock) on opf.cd_operacao_fiscal       = n.cd_operacao_fiscal  
  left outer join grupo_operacao_fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal  
  
where  
  n.cd_status_nota = 5                              and  
  n.dt_nota_saida between @dt_inicial and @dt_final and  
  n.dt_cancel_nota_saida is null                    and  
  gof.cd_tipo_operacao_fiscal = 1                   --ENTRADAS  
  
group by  
  i.cd_produto  

--select * from nota_entrada_item

select  
  i.cd_produto,  
  sum( isnull(i.qt_item_nota_entrada,0) ) as qt_entrada  
into  
  #Entrada
  
from  
  nota_entrada_item i                       with (nolock)   
--  inner join nota_saida n                   with (nolock) on n.cd_nota_saida              = i.cd_nota_saida  
  left outer join operacao_fiscal opf       with (nolock) on opf.cd_operacao_fiscal       = i.cd_operacao_fiscal  
  left outer join grupo_operacao_fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal  
  
where  
  --n.cd_status_nota = 5                              and  
  i.dt_item_receb_nota_entrad between @dt_inicial and @dt_final and  
--  n.dt_cancel_nota_saida is null                    and  
  gof.cd_tipo_operacao_fiscal = 1                   --ENTRADAS  
  
group by  
  i.cd_produto  

  
--select * from nota_saida  
--select * form   
  
  
--Faturamento SP  
  
select  
  i.cd_produto,  
  sum( isnull(i.qt_item_nota_saida,0) ) as qt_faturado  
into  
  #Faturado  
  
from  
  nota_saida_item i                         with (nolock)   
  inner join nota_saida n                   with (nolock) on n.cd_nota_saida              = i.cd_nota_saida  
  left outer join operacao_fiscal opf       with (nolock) on opf.cd_operacao_fiscal       = n.cd_operacao_fiscal  
  left outer join grupo_operacao_fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal  
  
where  
   n.cd_status_nota = 5                                
   and n.dt_nota_saida between @dt_inicial and @dt_final   
   and n.dt_cancel_nota_saida is null                      
   and gof.cd_tipo_operacao_fiscal = 2                    --SAIDAS  
--  gof.ic_procedencia_op_fiscal = 'E'                    --ESTADO  
   and gof.ic_estado_grupo_op_fiscal = 'N'                --ESTADO   
--   and isnull(opf.ic_comercial_operacao,'N')='S'          --COMERCIAL  
     and isnull(opf.ic_estoque_op_fiscal,'N') ='S'

  
group by  
  i.cd_produto  
  
  
--Faturamento Fora SP  
  
select  
  i.cd_produto,  
  sum( isnull(i.qt_item_nota_saida,0) ) as qt_faturado_fora  
  
into  
  #FaturadoFora  
  
from  
  nota_saida_item i                         with (nolock)   
  inner join nota_saida n                   with (nolock) on n.cd_nota_saida              = i.cd_nota_saida  
  left outer join operacao_fiscal opf       with (nolock) on opf.cd_operacao_fiscal       = n.cd_operacao_fiscal  
  left outer join grupo_operacao_fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal  
  
 where  
   n.cd_status_nota = 5                                
   and n.dt_nota_saida between @dt_inicial and @dt_final   
   and n.dt_cancel_nota_saida is null                      
   and gof.cd_tipo_operacao_fiscal = 2                    --SAIDAS  
   --and gof.ic_procedencia_op_fiscal = 'F'                    --FORA DO ESTADO  
   and gof.ic_estado_grupo_op_fiscal = 'S'   
--   and isnull(opf.ic_comercial_operacao,'N')='S'                   --COMERCIAL  
     and isnull(opf.ic_estoque_op_fiscal,'N') ='S'
     and isnull(gof.cd_digito_grupo,0) <> 7             --Exportação

group by  
  i.cd_produto  

--select * from grupo_operacao_fiscal

--Faturamento Exportação

select  
  i.cd_produto,  
  sum( isnull(i.qt_item_nota_saida,0) ) as qt_faturado_exportacao  
  
into  
  #FaturadoExportacao  
  
from  
  nota_saida_item i                         with (nolock)   
  inner join nota_saida n                   with (nolock) on n.cd_nota_saida              = i.cd_nota_saida  
  left outer join operacao_fiscal opf       with (nolock) on opf.cd_operacao_fiscal       = n.cd_operacao_fiscal  
  left outer join grupo_operacao_fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal  

 where  
   n.cd_status_nota = 5                                
   and n.dt_nota_saida between @dt_inicial and @dt_final   
   and n.dt_cancel_nota_saida is null                      
   and gof.cd_tipo_operacao_fiscal = 2                    --SAIDAS  
   and gof.ic_procedencia_op_fiscal = 'I'                    --FORA DO ESTADO  
   and gof.ic_estado_grupo_op_fiscal = 'S'   
--   and isnull(opf.ic_comercial_operacao,'N')='S'                   --COMERCIAL  
     and isnull(opf.ic_estoque_op_fiscal,'N') ='S'
     and isnull(gof.cd_digito_grupo,0) = 7             --Exportação

--select * from grupo_operacao_fiscal

group by  
  i.cd_produto  


--select * from grupo_operacao_fiscal  
--select * from operacao_fiscal  
  
--Mostra a Tabela Final  
  
  
select  
  p.cd_produto,  
  p.nm_fantasia_produto,  
  p.cd_mascara_produto,  
  p.nm_produto,  
  um.sg_unidade_medida,  
  atp.nm_tipo_produto,
  ac.nm_classificacao,  
  cp.nm_categoria_produto,
  p.cd_certificado_produto,
  
  cast(pimp.ds_produto_importacao as varchar(60))             as nm_grupo_importacao,

  --Valores de Estoque
  cast(isnull(ei.qt_inicial,0) as decimal(25,2))              as qt_inicial,  

  cast(isnull(ef.qt_final,0)
  -
  isnull(m.qt_movimento,0) as decimal(25,2))                  as qt_final,  

  isnull(i.qt_importacao,0) +
  isnull(e.qt_entrada,0)                                      as qt_importacao,  

  isnull(e.qt_entrada,0)                                      as qt_entrada,

  cast( isnull(f.qt_faturado,0) as decimal(25,2)            ) as qt_faturado,  

  cast(isnull(ff.qt_faturado_fora,0) as decimal(25,2))        as qt_faturado_fora,

  isnull(fe.qt_faturado_exportacao,0)                         as qt_faturado_exportacao,

  isnull(m.qt_movimento,0)                                    as qt_movimento,
  isnull(pa.nm_pais,'')                                       as nm_pais,
  cast(pe.nm_pais_exportacao as varchar(40))                  as nm_pais_destino,
  0.00                                                        as qt_produto_ep,
  0.00                                                        as qt_devolucao,
  cast('' as varchar(40))                                     as nm_destinacao

--pais

from  
  
  Produto p                                    with (nolock)    
  left outer join Status_Produto  sp           with (nolock) on sp.cd_status_produto    = p.cd_status_produto  
  left outer join Unidade_Medida  um           with (nolock) on um.cd_unidade_medida    = p.cd_unidade_medida  
  left outer join #EstoqueInicial ei           with (nolock) on ei.cd_produto           = p.cd_produto  
  left outer join #EstoqueFinal   ef           with (nolock) on ef.cd_produto           = p.cd_produto  
  left outer join #Importacao     i            with (nolock) on i.cd_produto            = p.cd_produto  
  left outer join #Faturado       f            with (nolock) on f.cd_produto            = p.cd_produto  
  left outer join #FaturadoFora   ff           with (nolock) on ff.cd_produto           = p.cd_produto  
  left outer join #Entrada        e            with (nolock) on e.cd_produto            = p.cd_produto  
  left outer join Produto_Importacao pimp      with (nolock) on pimp.cd_produto         = p.cd_produto
  left outer join #Movimento      m            with (nolock) on m.cd_produto            = p.cd_produto
  left outer join #FaturadoExportacao fe       with (nolock) on fe.cd_produto           = p.cd_produto  
  left outer join Categoria_Produto     cp     with (nolock) on cp.cd_categoria_produto = p.cd_categoria_produto
  left outer join Produto_Classificacao pc     with (nolock) on pc.cd_produto           = p.cd_produto  
  left outer join Agricultura_Tipo_Produto atp with (nolock) on atp.cd_tipo_produto     = pc.cd_tipo_produto
  left outer join Agricultura_Classificacao ac with (nolock) on ac.cd_classificacao     = pc.cd_classificacao 
  left outer join Pais pa                      with (nolock) on pa.cd_pais              = pimp.cd_pais
  left outer join #PaisExportacao pe           with (nolock) on pe.cd_produto           = p.cd_produto
--select * from produto_importacao
--select * from produto
  
where  
   p.nm_fantasia_produto is not null         and  
   isnull(ic_bloqueia_uso_produto,'N') = 'N' and  
   isnull(p.ic_comercial_produto,'N')  = 'S' and
   p.cd_grupo_produto = 1 --Temporáriamente
 
  
order by  
  p.nm_produto  
  
  
--select * from status_produto  
--select * from nota_saida_item      
--select * from operacao_fiscal  
--select * from grupo_operacao_fiscal  
--select * from nota_saida  
  
  
--select * from   

