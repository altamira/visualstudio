

----------------------------------------------------------------------
--pr_nota_credito
----------------------------------------------------------------------
--GBS - Global Business Solution Ltda                             2004
----------------------------------------------------------------------
--Stored Procedure     : Microsoft Sql Server 2000
--Autor(es)            : Carlos Cardoso Fernandes
--Banco de Dados       : EgisSql ou EgisAdmin
--Objetivo             : 
--Data                 : 06/01/2005
--Atualização          : Acerto do Cabeçalho - Sérgio Cardoso 
-- 19.03.2009 - Ajustes Diversos - Carlos Fernandes
-----------------------------------------------------------------------
CREATE PROCEDURE pr_nota_credito
@ic_parametro      int,
@dt_inicial        datetime,
@dt_final          datetime,
@cd_nota_credito   int,
@cd_cliente        int


as
-------------------------------------------------------------------------------
 if @ic_parametro = 2  -- Listagem das Notas de Crédito do Período
-------------------------------------------------------------------------------
  begin
    select 
      n.ic_emitida_nota_credito   as 'Emitido',
      n.cd_nota_credito           as 'CodNotaCredito',
      c.nm_fantasia_cliente       as 'Cliente',
      n.dt_emissao_nota_credito   as 'Emissao',
      n.dt_vencto_nota_credito    as 'Vencimento',
      n.vl_nota_credito           as 'VlNotaCredito'

    from
      Nota_Credito n
    left outer join
      Cliente c
    on
      n.cd_cliente = c.cd_cliente
    where
      n.dt_emissao_nota_credito between @dt_inicial and @dt_final
  end      

-------------------------------------------------------------------------------
else if @ic_parametro = 3  -- Listagem das Notas de Saída de Notas de Crédito por Nota
-------------------------------------------------------------------------------

  begin
    select 
      d.cd_item_nota_credito      as 'Item',
      d.cd_nota_saida             as 'NotaSaida',
      ns.dt_cancel_nota_saida,
      d.vl_item_nota_credito      as 'VlItem',
      d.nm_item_obs_nota_credito  as 'ObsItem'

    from
      Nota_Credito_Item d
    left outer join
      Nota_Credito n
    on
      d.cd_nota_credito = n.cd_nota_credito
    left outer join
      Nota_Saida ns
    on
      ns.cd_nota_saida = d.cd_nota_saida
    where
      d.cd_nota_credito = @cd_nota_credito

/*    select 
      n.cd_nota_credito           as 'CodNotaCredito',
      n.cd_nota_saida             as 'NotaSaida',
      nota.vl_total                  as 'VlNota',
      n.dt_nota_saida_credito     as 'Emissao',
      n.vl_nota_saida_credito     as 'Valor'

    from
      Nota_Saida_Credito n
    left outer join
      Nota_Saida nota
    on
      nota.cd_nota_saida = n.cd_nota_saida
    where
      n.cd_nota_credito = @cd_nota_credito */

  end   

---------------------------------------------------------------------------------------------------------
else if @ic_parametro = 4  -- Listagem dos Clientes que possuem nota de Crédito para Emissão das Mesmas
---------------------------------------------------------------------------------------------------------
  begin    

    IF EXISTS (SELECT name 
	     FROM   sysobjects 
 	     WHERE  name = N'#Cliente_Nota_Credito' 
	     AND 	  type = 'U')
      truncate table #Cliente_Nota_Credito

    select distinct
      0                         	      as 'Emitir',
      c.nm_fantasia_cliente        	      as 'Cliente',
      s.cd_cliente                	      as 'CodCliente',
      IsNull(p.vl_nota_saida_credito,0)       as 'ValorNotaCredito'
    into
      #Cliente_Nota_Credito

    from 
      Nota_Saida s                         with (nolock) 
      left outer join Nota_Saida_Credito p with (nolock) on p.cd_nota_saida = s.cd_nota_saida
      left outer join Cliente c            with (nolock) on s.cd_cliente    = c.cd_cliente
    where
        --s.cd_nota_saida = p.cd_nota_saida and
      -- somente os que o pagamento for entre a data escolhida
--      p.dt_nota_saida_credito between @dt_inicial and @dt_final and
      -- somente os que não foram emitidos Nota de Credito
      IsNull(p.ic_nota_credito,'N') = 'N' and
      -- somente as devolvidas no período
       p.dt_nota_saida_credito between @dt_inicial and @dt_final 

    --Documentos a Receber com Crédito Pendente

    select distinct
      0                         	      as 'Emitir',
      c.nm_fantasia_cliente        	      as 'Cliente',
      dr.cd_cliente                	      as 'CodCliente',
      IsNull(drp.vl_credito_pendente,0)       as 'ValorNotaCredito'
    into
      #Cliente_Documento_Receber

    from 
      Documento_Receber_Pagamento drp with (nolock) 
      inner join Documento_Receber dr with (nolock) on dr.cd_documento_receber = drp.cd_documento_receber
      left outer join Cliente c       with (nolock) on c.cd_cliente            = dr.cd_cliente
    where
      drp.dt_pagamento_documento between @dt_inicial and @dt_final
      and isnull(drp.vl_credito_pendente,0)>0

    insert into 
      #Cliente_Nota_Credito
    select * from #Cliente_Documento_Receber

 
--select * from nota_saida_credito

    select
      Emitir,
      Cliente,
      CodCliente,
      sum(ValorNotaCredito) as 'ValorNotaCredito',
      count(*)              as 'QtdeDocs'
    from
      #Cliente_Nota_Credito

    where
      ValorNotaCredito <> 0.00
    group by
      Cliente,
      Emitir,
      CodCliente
    order by
      Cliente

  end


----------------------------------------------------------------------------------------
else if @ic_parametro = 5  -- Listagem Duplicatas Devolvidas para Geração dos Itens da Nota de Crédito por cliente.
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
  begin
--sp_help Documento_receber
--select cd_documento_receber, cd_nota_saida, vl_documento_receber, vl_pagto_document_receber from Documento_Receber where cd_nota_saida = 17315order by cd_nota_saida
  --Consulta de notas fiscais com devolução

  select distinct
    0                                  as 'GerarNota',
    dr.cd_nota_saida,
    dr.cd_documento_receber            as 'Duplicata',
    dr.cd_identificacao,
    dr.dt_emissao_documento,
    drp.vl_pagamento_documento         as 'vl_total',
    isnull(drp.vl_credito_pendente,0)  as 'vl_credito_pendente',

    --cast( nsi.nm_motivo_restricao_item as varchar(40)) as 'nm_motivo_restricao_item',
    dr.cd_cliente                      as CodCliente,
    drp.dt_pagamento_documento

    --select * from documento_receber_pagamento

  from
    Documento_Receber dr  with (nolock) 
    left outer join Documento_Receber_pagamento drp on drp.cd_documento_receber = dr.cd_documento_receber
    left outer join Nota_Saida_Credito nsc          on dr.cd_nota_saida         = nsc.cd_nota_saida 
  where
      -- somente os que não foram emitidos Nota de Credito
      IsNull(nsc.ic_nota_credito,'N') = 'N' and
      dr.cd_cliente = @cd_cliente           and
      isnull(drp.vl_credito_pendente,0)>0
       
  end

-------------------------------------------------------------------------------
else if @ic_parametro = 6  -- Pesquisa de Uma única Nota de Crédito
-------------------------------------------------------------------------------
  begin
    select 
      cli.nm_razao_social_cliente as 'Cliente',
      d.cd_item_nota_credito      as 'Item',
      d.cd_nota_saida             as 'NotaSaida',
      d.vl_item_nota_credito      as 'VlItem',
      d.nm_item_obs_nota_credito  as 'ObsItem',
      n.vl_nota_credito           as 'VlNota',
      n.cd_nota_credito           as 'CodNotaCredito',
      n.dt_emissao_nota_credito   as 'Emissao',
      n.dt_vencto_nota_credito    as 'Vencimento',
      n.ds_nota_credito,
      n.cd_usuario,
      n.dt_usuario,
      dr.cd_identificacao         as 'Duplicata', 
      n.dt_pagamento_nota_credito,
      n.vl_pagamento_nota_credito,
      n.dt_cancelamento_nota_cred,
      n.nm_motivo_cancelamento

    from
      Nota_Credito n
    left outer join
      Nota_Credito_Item d
    on
      d.cd_nota_credito = n.cd_nota_credito
    left outer join
      Cliente Cli
    on
      cli.cd_cliente = n.cd_cliente
    left outer join
      Documento_Receber dr  
     on dr.cd_nota_saida = d.cd_nota_saida 
    where
      n.cd_nota_credito = @cd_nota_credito 


--    select * from
--      Nota_Credito
 --   where
  --    cd_cliente = @cd_cliente

  end 
-------------------------------------------------------------------------------
else if @ic_parametro = 7  -- Documentos de uma Nota de Crédito p/ Relatório
-------------------------------------------------------------------------------
  begin

    select 
      d.cd_nota_credito           as 'NotaCredito',
      ni.cd_nota_saida             as 'NotaSaida',
      d.dt_emissao_nota_credito   as 'Emissao',
      d.dt_vencto_nota_credito    as 'Vencimento',
      cast(str(d.vl_nota_credito,25,2) as decimal(25,2))  as 'Valor',
      cli.nm_razao_social_cliente,
      cli.cd_cnpj_cliente as 'CGC',
      cli.nm_endereco_cliente as 'Endereco', 
      cli.cd_numero_endereco as 'NumeroEnd',
      cid.nm_cidade as 'Cidade',
      est.nm_estado as 'Estado',
      cli.cd_cep as 'CEP',
      d.ds_nota_credito as 'Historico'

    from
      Nota_Credito d,
      Nota_Credito_Item ni,
      Cliente cli,
      Cidade cid,
      Estado est
    where
      d.cd_nota_credito = @cd_nota_credito and
      cli.cd_cliente    = d.cd_cliente     and
      est.cd_estado     = cli.cd_estado    and
      ni.cd_nota_credito = d.cd_nota_credito and
      cid.cd_cidade     = cli.cd_cidade      


  end 
-------------------------------------------------------------------------------
else if @ic_parametro = 8   -- Relatório por Extenso
-------------------------------------------------------------------------------
  begin

    select 
      d.cd_nota_credito           as 'NotaCredito',
      d.dt_emissao_nota_credito   as 'Emissao',
      d.dt_vencto_nota_credito    as 'Vencimento',
      IsNull(cast(d.vl_nota_credito as decimal(25,2)), ni.vl_item_nota_credito)  as 'Valor',
      cast(str(ni.vl_item_nota_credito,25,2) as decimal(25,2)) as 'VlItem',
      cli.nm_razao_social_cliente,
      cli.nm_endereco_cliente + ', ' + IsNull(cli.cd_numero_endereco, '') + ' - ' + cli.nm_bairro as 'Endereco', 
      cli.cd_cep + ' - ' + cid.nm_cidade + ' - ' + est.sg_estado as 'Cid_Estado_CEP',
      n.vl_total as 'ValorNota',
      n.dt_nota_saida as 'EmissaoNota',
      ni.cd_nota_saida as 'NotaFiscal'

    from
      Nota_Credito d
    left outer join
      Nota_Credito_Item ni
    on
      ni.cd_nota_credito = d.cd_nota_credito
    left outer join
      Cliente cli
    on
      cli.cd_cliente    = d.cd_cliente
    left outer join
      Cidade cid
    on
      cid.cd_cidade     = cli.cd_cidade      
    left outer join
      Estado est
    on
      est.cd_estado     = cli.cd_estado
    left outer join
      Nota_Saida n
    on
      n.cd_nota_saida   = ni.cd_nota_saida

    where
      d.cd_nota_credito = @cd_nota_credito




  end    




