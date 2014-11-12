
CREATE PROCEDURE pr_consulta_produto_nao_valorado_peps
-------------------------------------------------------------------------------------------------
--pr_consulta_produto_nao_valorado_peps
-------------------------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda                     2004
-------------------------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Ludinei/Elias
--Banco de Dados        : EgisSql
--Objetivo              : Consulta de Produtos não valorados PEPS
--Data                  : 20/04/2004
--Atualização           : 24/05/2004 - Otimização e reestruturação - DANIEL DUELA
--                      : 30/12/2004 - Acerto do Cabeçalho  - Sérgio Cardoso
--                      : 04/02/2005 - Acerto da Rotina de Consulta
--                      : 21/02/2005 - Acertos na máscara e retorno do fantasia - Clelson Camargo
-------------------------------------------------------------------------------------------------
@cd_grupo_produto int,
@dt_inicial       datetime,
@dt_final         datetime

as


 select 
  p.cd_produto                         as Codigo,
  dbo.fn_mascara_produto(p.cd_produto) as Mascara, -- p.cd_mascara_produto Clelson(21.02.2005)
  p.nm_fantasia_produto                as Fantasia,
  p.cd_grupo_produto,
  gp.nm_grupo_produto         as Grupo, 
  p.nm_produto                as Descricao, 
  pf.qt_atual_prod_fechamento as Quantidade, 
  um.sg_unidade_medida        as UnidadeMedida
 into 
  #NaoPeps
 from 
  Produto p
  left outer join Grupo_Produto gp      on p.cd_grupo_produto=gp.cd_grupo_produto
  left outer join Produto_Custo pc      on p.cd_produto      =pc.cd_produto
  left outer join Produto_Fechamento pf on p.cd_produto      =pf.cd_produto and
                                         pf.cd_fase_produto=  (select cd_fase_produto
                                         from
                                           parametro_comercial
                                         where
                                           cd_empresa = dbo.fn_empresa())
  left outer join Unidade_Medida um     on p.cd_unidade_medida = um.cd_unidade_medida
 where 
  isnull(p.cd_grupo_produto,0) = case when isnull(@cd_grupo_produto,0)=0 then p.cd_grupo_produto else @cd_grupo_produto end and
  p.cd_status_produto=1                 and --Produto Ativo
  isnull(p.ic_producao_produto,'N')='N' and
  isnull(pc.ic_peps_produto,'N')   ='N' and
  --pf.qt_atual_prod_fechamento>0         and
  pf.dt_produto_fechamento = @dt_final 

--  order by 
--   p.cd_mascara_produto
-- Clelson(21.02.2005)


--Verifica se os Grupos que estão selecionados são de Revenda
--if @cd_grupo_produto=0
--begin

  delete from #NaoPeps
  where
    cd_grupo_produto in ( select cd_grupo_produto from Grupo_Produto where isnull(ic_revenda_grupo_produto,'N')='N')

--end


 select 
  a.Codigo,
  max(nsi.vl_unitario_item_nota) as 'Preco',
  max(ns.cd_nota_saida)          as 'Nota_Fiscal',
  max(ns.dt_nota_saida)          as 'Data_Faturamento'
 into 
  #FatMes
 from 
  #NaoPeps a
 left outer join nota_saida_item nsi on a.Codigo = nsi.cd_produto
 left outer join nota_saida ns       on nsi.cd_nota_saida = ns.cd_nota_saida
 where 
  ns.dt_nota_saida between @dt_inicial and @dt_final and 
  isnull(ns.dt_cancel_nota_saida,'')=''
 group by 
  a.Codigo

 select 
  a.*,
  b.Preco,
  b.Nota_Fiscal,
  b.Data_Faturamento 
 from 
  #NaoPeps a 
 left outer join #FatMes b on a.Codigo = b.Codigo
 where
  isnull(a.quantidade,0)<>0
 order by
  cd_grupo_produto -- Mascara Clelson(21.02.2005)

 drop table #NaoPeps
 drop table #FatMes

