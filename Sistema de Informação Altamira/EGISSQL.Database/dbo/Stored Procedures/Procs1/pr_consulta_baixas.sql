
CREATE PROCEDURE pr_consulta_baixas
@ic_parametro int, 
@cd_mascara_operacao varchar(30),
@dt_inicial datetime,
@dt_final datetime


AS
      SELECT distinct
         NV.dt_baixa_nota as 'Data_Baixa',  
         NS.dt_nota_saida as 'Emissao', 
--         NS.cd_nota_saida as 'Nota',
         case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
           ns.cd_identificacao_nota_saida
         else
           ns.cd_nota_saida
         end                            as 'Nota',

         NS.cd_operacao_fiscal,
         NS.cd_tipo_destinatario,
         NS.nm_fantasia_destinatario as 'Destinatario', 
         OFI.cd_mascara_operacao as 'Operacao_Fiscal', 
         OFI.ic_retorno_op_fiscal, 
         TD.nm_tipo_destinatario as 'Tipo_Destinatario',  
         NSI.cd_item_nota_saida as 'Item', 
         NSI.vl_total_item as 'Valor',
         NSI.qt_item_nota_saida as 'Quantidade',
         NV.vl_saldo_nota as 'Saldo',
         NSI.nm_fantasia_produto,
         NSI.pc_icms, 
         NSI.pc_ipi, 
         nvb.cd_nota_entrada,
         nvb.dt_nota_entrada,
      	 nvb.vl_nota_entrada
      FROM         
         Nota_Saida NS 
      INNER JOIN
         Nota_Vencimento NV ON NS.cd_nota_saida = NV.cd_nota_fiscal 
      INNER JOIN
         Operacao_Fiscal OFI ON NS.cd_operacao_fiscal = OFI.cd_operacao_fiscal 
      INNER JOIN
         Tipo_Destinatario TD ON NS.cd_tipo_destinatario = TD.cd_tipo_destinatario 
      INNER JOIN
         Nota_Saida_Item NSI ON NS.cd_nota_saida = NSI.cd_nota_saida
      INNER JOIN
 	 Nota_Vencimento_Baixa nvb on nvb.cd_nota_fiscal = nv.cd_nota_fiscal
      where
         (NV.vl_saldo_nota = 0) and 
         ((case when @ic_parametro = 0 then
             IsNull(NV.dt_baixa_nota,'') else
             NS.dt_nota_saida end ) between @dt_inicial and @dt_final) and
	 (OFI.cd_mascara_operacao like @cd_mascara_operacao + '%')    

