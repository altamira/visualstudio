
CREATE PROCEDURE pr_consulta_remessas_aberto
--parametros da stored procedure
@ic_parametro int, 
@cd_mascara_operacao varchar(30),
@dt_inicial datetime,
@dt_final datetime

AS
      SELECT     
         NS.cd_nota_saida, 
         NV.dt_vencimento_nota, 
         NS.dt_nota_saida, 
         NS.cd_operacao_fiscal, 
         NS.cd_tipo_destinatario, 
         NSI.cd_item_nota_saida, 
         OFI.cd_mascara_operacao, 
         TD.nm_tipo_destinatario, 
         PRO.nm_fantasia_produto, 
         NSI.pc_icms, 
         NSI.pc_ipi, 
         NSI.vl_total_item, 
         NS.nm_fantasia_destinatario,
         NV.vl_saldo_nota,
         NSI.qt_item_nota_saida
      FROM         
         Nota_Saida NS 
      left outer join
         Operacao_Fiscal OFI ON NS.cd_operacao_fiscal = OFI.cd_operacao_fiscal 
      left outer join
         Nota_Vencimento NV ON NS.cd_nota_saida = NV.cd_nota_fiscal 
      left outer join
         Tipo_Destinatario TD ON NS.cd_tipo_destinatario = TD.cd_tipo_destinatario 
      INNER JOIN
         Nota_Saida_Item NSI ON NS.cd_nota_saida = NSI.cd_nota_saida
      inner join
         Produto PRO ON NSI.cd_produto = PRO.cd_produto
      where 
         (NV.vl_saldo_nota > 0) and
         ((case when @ic_parametro = 0 then
             NV.dt_vencimento_nota else
             NS.dt_nota_saida end ) between @dt_inicial and @dt_final) and
         (IsNull(OFI.cd_mascara_operacao,'') like @cd_mascara_operacao + '%')
      order by
         NS.dt_nota_saida
