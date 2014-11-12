
CREATE PROCEDURE pr_verifica_nota_saida_emitida
@ic_parametro int,
@dt_inicial   datetime,
@dt_final     datetime

as
 
     select 
       ns.cd_nota_saida,
       ns.dt_nota_saida,
       ns.ic_emitida_nota_saida,
      ofi.cd_mascara_operacao,
      ofi.nm_operacao_fiscal,
      ofi.ic_estoque_op_fiscal
     from
       Nota_Saida      ns  left outer join Operacao_Fiscal ofi on ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal
                           left outer join Nota_Saida_item nsi on nsi.cd_nota_saida      = ns.cd_nota_saida
         
     where
       ns.dt_nota_saida between @dt_inicial and @dt_final    and
       isnull(ns.ic_emitida_nota_saida,'N') = 'N'            and
       isnull(ofi.ic_estoque_op_fiscal,'N') = 'S'            and
       isnull(nsi.cd_produto,0) > 0                          
   
           

--select * from operacao_fiscal
--select * from nota_saida
