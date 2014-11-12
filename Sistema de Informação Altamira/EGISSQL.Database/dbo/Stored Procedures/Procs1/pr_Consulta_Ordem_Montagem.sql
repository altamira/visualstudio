
CREATE PROCEDURE pr_Consulta_Ordem_Montagem

@nm_fantasia_produto char(30),
@Versao              int,
@cd_ordem_montagem int
as
declare @saldo_atual int
set @saldo_atual = (select sum(qt_saldo_atual_produto) from produto_saldo) 
Select
  distinct  
  @saldo_atual            as 'SaldoFisico',
  pc.nm_obs_produto_composicao        as 'ObsOrdemMontagem',
  om.cd_ordem_montagem                as 'OrdemdeMomtagem',
  om.dt_ordem_montagem                as 'DatadeMontagem',  
  pc.cd_produto_pai                   as 'ProdutoPaiComp',
  pc.cd_item_produto                  as 'IdProdutoComp',       
  pc.cd_produto                       as 'CodigoProduto',
  p.nm_fantasia_produto               as 'NomeFantasia',
  pc.qt_produto_composicao            as 'QtdeProdutoComp',
  isnull(c.nm_fantasia_produto,' ')   as 'NomeFantasiaComp',
  isnull(c.nm_produto,' ')            as 'DescricaoComp',
  isnull(dbo.fn_mascara_produto(c.cd_produto),' ')    as 'MascaraComp',
  IsNull(pc.cd_fase_produto,0)        as 'cd_fase_produto',
  IsNull(pc.cd_ordem_produto_comp,0)  as 'cd_ordem_produto_comp',
  IsNull(pc.cd_versao_produto_comp,0) as 'cd_versao_produto_comp',
  p.cd_unidade_medida                 as 'cd_unidade_medida',
  p.qt_leadtime_produto               as 'qt_leadtime',
  p.qt_leadtime_compra                as 'qt_leadtime_compra',
  p.cd_grupo_produto                  as 'cd_grupo_produto',
  IsNull(pc.cd_versao_produto,0)      as 'cd_versao_produto'
-------
into 
  #TmpArvorePai
-------
from
  Produto p
  Left Join Produto_Composicao pc
  On p.cd_produto = pc.cd_produto_pai

  Left Join Produto c
  On pc.cd_produto = c.cd_produto

  Left join Ordem_Montagem_item omi
  On p.cd_produto = omi.cd_produto 
  
  Left join Ordem_Montagem om 
  On om.cd_ordem_montagem = omi.cd_ordem_montagem 
  
  Left Outer Join Produto_Saldo d on
       p.cd_produto = d.cd_produto and
       d.cd_fase_produto = pc.cd_fase_produto

  where (p.nm_fantasia_produto = @nm_fantasia_produto) and
        (pc.cd_versao_produto_comp = @Versao)and
        (om.cd_ordem_montagem = @cd_ordem_montagem)

select * from #TmpArvorePai
-- Tabela auxiliar para guardar todas as árvores filho

Select
  distinct
  d.qt_saldo_atual_produto            as 'SaldoFisico',
  pc.nm_obs_produto_composicao        as 'ObsOrdemMontagem',
  om.cd_ordem_montagem                as 'OrdemdeMomtagem',
  om.dt_ordem_montagem                as 'DatadeMontagem',  
  p.cd_produto                       as 'ProdutoPaiComp',
  0			             as 'IdProdutoComp',       
  p.cd_produto                       as 'CodigoProduto',
  p.nm_fantasia_produto              as 'NomeFantasia',
  cast(1.0 as float)	             as 'QtdeProdutoComp',
  isnull(p.nm_fantasia_produto,' ')  as 'NomeFantasiaComp',
  isnull(p.nm_produto,' ')           as 'DescricaoComp',
  isnull(dbo.fn_mascara_produto(p.cd_produto),' ')   as 'MascaraComp',
  0				     as 'cd_fase_produto',
  0                                  as 'cd_ordem_produto_comp',
  @Versao			     as 'cd_versao_produto_comp',
  p.cd_unidade_medida                as 'cd_unidade_medida',
  p.qt_leadtime_produto              as 'qt_leadtime',
  p.qt_leadtime_compra               as 'qt_leadtime_compra',
  p.cd_grupo_produto                 as 'cd_grupo_produto',
  @Versao			     as 'cd_versao_produto'
-------
into #TmpArvoreFinal
-------
from
  Produto p
    Left join Ordem_Montagem_item omi
    On p.cd_produto = omi.cd_produto 
  
    Left join Ordem_Montagem om 
    On om.cd_ordem_montagem = omi.cd_ordem_montagem 

      Left Join Produto_Composicao pc
    On p.cd_produto = pc.cd_produto_pai
 
Left Outer Join Produto_Saldo d on
       p.cd_produto = d.cd_produto and
       d.cd_fase_produto = pc.cd_fase_produto

where 
    (p.nm_fantasia_produto = @nm_fantasia_produto )and
    (om.cd_ordem_montagem = @cd_ordem_montagem)
--select * from #TmpArvoreFinal

insert into #TmpArvoreFinal
select * from #TmpArvorePai

-- Variáveis auxiliares no loop para buscar todas as árvores abaixo da principal

declare @cd_produto int
declare @cd_produto_pai int
declare @cd_item_produto int
declare @nm_fantasia_filho char(30)
declare @cd_versao_produto int

while Exists (Select codigoproduto from #TmpArvorePai)
begin

--select * from #tmparvorepai

   select top 1 
          @cd_produto            = isnull(codigoproduto,0),
          @cd_item_produto       = isnull(idprodutocomp,0),
          @nm_fantasia_filho     = IsNull(nomefantasiacomp,''),
          @cd_versao_produto     = IsNull(cd_versao_produto_comp,0)
   from #TmpArvorePai


      insert into #TmpArvoreFinal
      Select
        distinct
        d.qt_saldo_atual_produto            as 'SaldoFisico',
        pc.nm_obs_produto_composicao        as 'ObsOrdemMontagem',
        om.cd_ordem_montagem               as OrdemdeMomtagem,
        om.dt_ordem_montagem               as DatadeMontagem,  
        a.cd_produto_pai                   as ProdutoPaiComp,
        a.cd_item_produto                  as IdProdutoComp,
        a.cd_produto                       as CodigoProduto,
        b.nm_fantasia_produto              as NomeFantasia,
        isnull(a.qt_produto_composicao,0)  as QtdeProdutoComp,
        c.nm_fantasia_produto              as NomeFantasiaComp,
        c.nm_produto                       as DescricaoComp,
        IsNull(dbo.fn_mascara_produto(c.cd_produto),' ')   as MascaraComp,
        IsNull(a.cd_fase_produto,0)        as cd_fase_produto,
        IsNull(a.cd_ordem_produto_comp,0)  as cd_ordem_produto_comp,
        IsNull(a.cd_versao_produto_comp,0) as cd_versao_produto_comp,
        IsNull(b.cd_unidade_medida,0)      as cd_unidade_medida,
        isnull(c.qt_leadtime_produto,0)    as qt_leadtime,
        isnull(c.qt_leadtime_compra,0)     as qt_leadtime_compra,
        b.cd_grupo_produto                 as cd_grupo_produto,
        IsNull(a.cd_versao_produto,0)      as cd_versao_produto
     from Produto_Composicao a

     Left Join Produto b
     On a.cd_produto_pai = b.cd_produto

     Left Join Produto c
     On a.cd_produto = c.cd_produto
     
     Left join Ordem_Montagem_item omi
     On a.cd_produto = omi.cd_produto 
  
     Left join Ordem_Montagem om 
     On om.cd_ordem_montagem = omi.cd_ordem_montagem 


      Left Join Produto_Composicao pc
      On a.cd_produto = pc.cd_produto_pai

   Left Outer Join Produto_Saldo d on
       a.cd_produto = d.cd_produto and
       d.cd_fase_produto = pc.cd_fase_produto

     where (a.cd_produto_pai = @cd_produto) and
           ( (a.cd_versao_produto_comp = @cd_Versao_produto) or
             (isnull(@cd_versao_produto,0) = 0)
           )and
           (om.cd_ordem_montagem = @cd_ordem_montagem)


       print('Passou!')
       print(@cd_produto)
       print(@cd_item_produto)
       print(@nm_fantasia_filho)
       print(@cd_versao_produto)

     -- Significa que ele é pai.
     if Exists (Select cd_produto 
                from produto_composicao 
                where cd_produto_pai=@cd_produto and
                ( (cd_versao_produto_comp = @cd_Versao_produto) or
                  (isnull(@cd_versao_produto,0) = 0)
                ) 
               )
     begin



       insert into #TmpArvorePai
       Select
         distinct
         d.qt_saldo_atual_produto            as 'SaldoFisico',
         pc.nm_obs_produto_composicao        as 'ObsOrdemMontagem',
         om.cd_ordem_montagem               as 'OrdemdeMomtagem',
         om.dt_ordem_montagem               as 'DatadeMontagem',  
         a.cd_produto_pai                   as 'ProdutoPaiComp',
         a.cd_item_produto                  as 'IdProdutoComp',       
         a.cd_produto                       as 'CodigoProduto',
         b.nm_fantasia_produto              as 'NomeFantasia',
         isnull(a.qt_produto_composicao,0)  as 'QtdeProdutoComp',
         c.nm_fantasia_produto              as 'NomeFantasiaComp',
         c.nm_produto                       as 'DescricaoComp',
         IsNull(dbo.fn_mascara_produto(c.cd_produto),' ')   as 'MascaraComp',
         IsNull(a.cd_fase_produto,0)        as 'cd_fase_produto',
         IsNull(a.cd_ordem_produto_comp,0)  as 'cd_ordem_produto_comp',
         IsNull(a.cd_versao_produto_comp,0) as 'cd_versao_produto_comp',
         IsNull(b.cd_unidade_medida,0)      as 'cd_unidade_medida',
         isnull(c.qt_leadtime_produto,0)    as 'qt_leadtime',
         isnull(c.qt_leadtime_compra,0)     as 'qt_leadtime_compra',
         b.cd_grupo_produto                 as 'cd_grupo_produto',
         a.cd_versao_produto                as 'cd_versao_produto' 
       from Produto_Composicao a

       Left Join Produto b
       On a.cd_produto_pai = b.cd_produto

       Left Join Produto c
       On a.cd_produto = c.cd_produto
       
       Left join Ordem_Montagem_item omi
       On a.cd_produto = omi.cd_produto 
  
       Left join Ordem_Montagem om 
       On om.cd_ordem_montagem = omi.cd_ordem_montagem 

      
 
       Left Join Produto_Composicao pc
       On a.cd_produto = pc.cd_produto_pai

      Left Outer Join Produto_Saldo d on
       a.cd_produto = d.cd_produto and
       d.cd_fase_produto = pc.cd_fase_produto

       where (a.cd_produto_pai    = @cd_produto) and
             ( (a.cd_versao_produto_comp = @cd_Versao_produto) or
               (isnull(@cd_versao_produto,0) = 0) 
             )and
           (om.cd_ordem_montagem = @cd_ordem_montagem) 
   
     end

     delete from #TmpArvorePai where CodigoProduto = @cd_produto

     -- Apaga Registro da Tabela Temporária    

     /*delete from 
       #TmpArvorePai
     where
       isnull(codigoproduto,0)  = @cd_produto and
       isnull(produtopaicomp,0) = @cd_produto_pai and
       isnull(idprodutocomp,0)  = @cd_item_produto */
       
end

select f.*,
       f.codigoproduto as 'Cd_Produto_Composicao',
       isnull (u.sg_unidade_medida,'') as sg_unidade_medida,
       fase.sg_fase_produto as nm_fase_produto
from #TmpArvoreFinal f

left join Unidade_medida u
on f.cd_unidade_medida = u.cd_unidade_medida

Left Join Fase_Produto fase
On f.cd_Fase_produto = Fase.cd_fase_produto


order by f.ProdutoPaiComp,
         f.cd_ordem_produto_comp

drop table #TmpArvoreFinal
drop table #TmpArvorePai

