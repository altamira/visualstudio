
create procedure pr_nota_entrada_sem_custo_aquisicao
@dt_inicial      datetime,
@dt_final        datetime
as 

 select
   p.cd_mascara_produto        as 'Codigo',
   p.nm_fantasia_produto       as 'Produto',
   p.nm_produto                as 'Descricao',
  um.sg_unidade_medida         as 'Unidade',
 nep.dt_documento_entrada_peps as 'Data', 
 nep.cd_documento_entrada_peps as 'Nota',
 nep.cd_item_documento_entrada as 'Item',
 nep.qt_entrada_peps           as 'Qtd',
   f.nm_fantasia_fornecedor    as 'Fornecedor'
 from  
   Produto p,
   Nota_Entrada_peps nep,
   Unidade_Medida um,
   Fornecedor f
 where
   p.cd_produto        = nep.cd_produto and 
   p.cd_unidade_medida = um.cd_unidade_medida and
   nep.cd_fornecedor   = f.cd_fornecedor and
   isnull(nep.vl_preco_entrada_peps,0)=0 and 
   nep.dt_documento_entrada_peps between @dt_inicial and @dt_final

--sp_help nota_entrada_peps

 
