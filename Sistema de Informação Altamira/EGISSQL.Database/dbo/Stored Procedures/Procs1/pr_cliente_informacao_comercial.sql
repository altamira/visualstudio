
CREATE PROCEDURE pr_cliente_informacao_comercial
-----------------------------------------------------------------------
--pr_cliente_informacao_comercial
-----------------------------------------------------------------------
--GBS-Global Business Solution Ltda                                2004
-----------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Elias P. Silva
--Banco de Dados        : Sap/SapSql
--Objetivo              : Listar informações comerciais do cliente
--Data                  : 10/12/2001
--Atualizado            : 15/01/2002 - Listar somente os 7 últimos títulos pagos do cliente. - Elias
--                      : 18/02/2002 - Conversão do Abatimento para Float. Eliminando erro do Delphi - Daniel 
--                      : 19/02/2002 - Adição do Campo de Fantasia - Daniel.
--                      : 28/02/2002 - Listagem das Notas de Débito - ELIAS
--                      : 06/03/2002 - Adição do Campo cd_documento_receber para Uso - Daniel.
--                      : 13/03/2002 - Modificação do campo vl_saldo_documento - Daniel C. Neto
--                      : 24/04/2002 - Inclusão dos campos cd_orgao_credito e dt_orgao_credito - Elias
--                      : 11/06/2002 - Inclusão do campo nm_orgao_credito - Elias
--                      : 07/08/2002 - Acerto dos campos de endereço que passar a ser usados da própria tabela de Clieente -  ELIAS
--                                     Acerto dos campos de CEP, CNPJ e Telefone para mostrar máscara corretamente- ELIAS
--                      : 24/10/2002 - Acerto no campo de vendedor - Daniel C. Neto.
--                      : 10/02/2003 - Não trazer notas de débito canceladas - Daniel C. Neto.
--                      : 25/02/2003 - Revisão - Carlos
--                      : 09/04/2003 - Se existir abatimento de Liquidação pega da tabela 'Documento_Receber_Pagamento'
--                      : 10/04/2003 - Acerto no valor de Abatimento dos Documentos em Aberto
--                      : 21/09/2004 - Acrescentado coluna tipo de mercado
--                      : 16/11/2004 - Acrescentado campo de Motivo da Última Liberação de Crédito - ELIAS
--                      : 03/12/2004 - Incluido o Total de Documentos Pagar - Carlos
--                      : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
-- 18.09.2008 - Verificação do Saldo do Limite de Crédito - Carlos Fernandes
------------------------------------------------------------------------------------------------------------------
  @ic_parametro int,
  @cd_cliente   int

AS

-------------------------------------------------------------------------------
if @ic_parametro = 1       -- lista os documentos do cliente
-------------------------------------------------------------------------------
  begin

    select
      top 7
      d.cd_documento_receber    as 'CodDocumento',
      d.cd_cliente              as 'Cliente',
      d.cd_identificacao        as 'Duplicata',
      d.dt_emissao_documento    as 'Emissao',
      d.dt_vencimento_documento as 'Vencimento',
      p.dt_pagamento_documento  as 'Pagamento',
      d.vl_documento_receber    as 'Valor',
      t.sg_portador             as 'Portador',
      cast(cast(d.dt_vencimento_documento as float) as int) - p.qt_dias_pagamento as 'Dias',
      (p.vl_abatimento_documento + p.vl_desconto_documento) as 'Abatimento',
      'N' as 'Saldo',
      1   as 'Ordem'
    into
      #Documento_Pago
    from
      portador t,
      documento_receber d,
      (select cd_documento_receber,
      isnull(max(dt_pagamento_documento), null) as dt_pagamento_documento,
      isnull(sum(vl_abatimento_documento),0) as vl_abatimento_documento,
      isnull(sum(vl_desconto_documento),0) as vl_desconto_documento,
      isnull(cast(cast(max(dt_pagamento_documento) as float) as int), cast(cast(getDate() as float) as int)) as qt_dias_pagamento
      from documento_receber_pagamento drp group by cd_documento_receber) p
    where
      p.cd_documento_receber = d.cd_documento_receber and
      d.cd_portador = t.cd_portador and
      d.cd_cliente = @cd_cliente and      
      cast(str(d.vl_saldo_documento ,25,2) as decimal(25,2)) = 0.00 and
      d.dt_cancelamento_documento is null and
      d.dt_devolucao_documento    is null
    order by
      Pagamento desc

   select * from #Documento_Pago
   union all
   -- listagem dos documentos em aberto
    select
      d.cd_documento_receber as 'CodDocumento',
      d.cd_cliente       as 'Cliente',
      d.cd_identificacao as 'Duplicata',
      d.dt_emissao_documento as 'Emissao',
      d.dt_vencimento_documento as 'Vencimento',
      cast(null as datetime) as 'Pagamento',
      cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) as 'Valor',
      t.sg_portador as 'Portador',
      cast(cast(d.dt_vencimento_documento as float) as int) - cast(cast(getDate() as float) as int) as 'Dias',
      isnull(d.vl_abatimento_documento,0) as 'Abatimento',
      case when exists(select 
                         top 1 
                         p.cd_documento_receber 
                       from
                         documento_receber_pagamento p
                       where
                         p.cd_documento_receber = d.cd_documento_receber) 
           then 'S' else 'N' end
      as 'Saldo',
      2 as 'Ordem'
--    into
--      #Documento_aberto
    from
      documento_receber d with (nolock) 
    left outer join
      portador t
    on
      d.cd_portador = t.cd_portador
    where
      (isnull(cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)), 0) > 0) and
      d.cd_cliente                = @cd_cliente and
      d.dt_cancelamento_documento is null and
      d.dt_devolucao_documento    is null
--    order by
--      Vencimento,
--      Duplicata
   union all
   -- listagem das notas de débito
   select 
     999999		   	 as 'CodDocumento',
     n.cd_cliente          	 as 'Cliente',
     cast(n.cd_nota_debito 	 as varchar(25)) as 'Duplicata',
     n.dt_nota_debito      	 as 'Emisssao',
     n.dt_vencimento_nota_debito as 'Vencimento',
     n.dt_pagamento_nota_debito  as 'Pagamento',
     n.vl_nota_debito     	 as 'Valor',
     'ND'        	         as 'Portador',
     cast((convert(int, n.dt_vencimento_nota_debito, 103) - convert(int, getDate(), 103)) as int) as 'Dias',
     0.00                 	 as 'Abatimento',
     'N'                  	 as 'Saldo',
     3 				 as 'Ordem'
--   into
--     #Nota_Debito
   from
     Nota_Debito n with (nolock) 
   where
     n.dt_pagamento_nota_debito is null and
     n.cd_cliente = @cd_cliente and 
     n.dt_cancelamento_nota_debi is Null
   order by
     Ordem, Pagamento, Vencimento, Duplicata

   -- junção das duas tabelas
--    insert into
--      #Documento_Aberto
--    select * from
--      #Documento_Pago

   -- junção da tabela de notas de débito
--    insert into
--      #Documento_Aberto
--    select * from
--      #Nota_Debito     

   -- resultado
--    select * from
--      #Documento_Aberto     
--    order by
--      Ordem

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2   -- listando a informação comercial do cliente
-------------------------------------------------------------------------------
  begin

    declare @vl_maior_acumulo float
    declare @dt_maior_acumulo datetime

    set     @vl_maior_acumulo           = 0.00
    set     @dt_maior_acumulo           = 0

    -- 3 - calculando maior acúmulo
--     exec pr_maior_acumulo_cliente 
--       @cd_cliente, 
--       @vl_maior_acumulo = @vl_maior_acumulo output,     
--       @dt_maior_acumulo = @dt_maior_acumulo output

    select
      i.*,
      @vl_maior_acumulo as vl_maior_acumulo_tratada,
      sc.nm_suspensao_credito,
      isnull(c.cd_cliente_sap, c.cd_cliente) as 'cd_cliente_sap',
      c.nm_razao_social_cliente,
      c.nm_fantasia_cliente,
      c.dt_cadastro_cliente,
      replace(replace(replace(c.cd_cnpj_cliente,'.',''),'/',''),'-','') as 'cd_cnpj_cliente',
      c.cd_inscestadual,
      c.nm_endereco_cliente+
      case when (isnull(c.cd_numero_endereco,'') <> '') then
        case when patindex(c.nm_endereco_cliente, ',') <> 0 then
          ', '
        else
          ' '
        end + 
        cast(c.cd_numero_endereco as varchar(25))+
          case when (isnull(c.nm_complemento_endereco,'') <> '') then
            ' - '+c.nm_complemento_endereco 
          else '' end
        else '' end
     as 'nm_endereco',
      c.nm_bairro,
     case when len(c.cd_telefone)>=10 then
      '('+c.cd_ddd+')'+EgisSql.dbo.fn_formata_telefone(replace(c.cd_telefone,'-','')) 
      else '('+c.cd_ddd+')'+c.cd_telefone end as 'cd_telefone',
      u.sg_estado,
      d.nm_cidade,
      case when patindex(c.cd_cep,'-') <> 0 then 
        c.cd_cep        
      else 
        substring(c.cd_cep,1,5)+'-'+substring(c.cd_cep,6,3)        
      end as 'cd_cep',
      cv.cd_vendedor,
      cv.nm_fantasia_vendedor as 'nm_vendedor',
      cv.nm_vendedor          as 'nm_social_vendedor',
      o.nm_orgao_credito,
      tm.nm_tipo_mercado,
      IsNull(tm.ic_exportacao_tipo_mercado ,'N') as 'ic_exportacao_tipo_mercado',
      IsNull(i.vl_operacao_cambio,0) as 'vl_operacao_cambio',
      IsNull(i.vl_embarque_cliente,0) as 'vl_embarque_cliente',
      c.cd_pais,
      isnull(ml.nm_motivo_liberacao,'Não Informado') as nm_motivo_liberacao,
      tp.nm_mascara_tipo_pessoa,
      c.cd_tipo_pessoa,
      tp.sg_tipo_pessoa,
      IsNull(i.vl_limite_credito_cliente,0) -  (IsNull((select Sum(IsNull(vl_saldo_documento,0))
                                                        from documento_receber with (nolock)
                                                        where cd_cliente = @cd_cliente and
                                                              isnull(vl_saldo_documento,0) > 0 and
                                                              dt_cancelamento_documento is null and
                                                              dt_devolucao_documento    is null
                                                        group by cd_cliente),0) +
                                                IsNull((select (Sum( (IsNull(pvi.qt_saldo_pedido_venda,0) * IsNull(pvi.vl_unitario_item_pedido,0))
                                                          * (1 + IsNull(pvi.pc_ipi,0) / 100) ) )
                                                        from pedido_venda_item pvi with (nolock)
                                                          inner join pedido_venda pv with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda
                                                        where pv.cd_cliente = @cd_cliente and
                                                              isnull(pvi.qt_saldo_pedido_venda,0) > 0 and
                                                              pvi.dt_cancelamento_item is null and
                                                              pv.dt_fechamento_pedido  is not null
                                                        group by pv.cd_cliente),0)) as vl_saldo_limite_credito,

       round(IsNull((select (Sum( (IsNull(pvi.qt_saldo_pedido_venda,0) * IsNull(pvi.vl_unitario_item_pedido,0))
                                                          * (1 + IsNull(pvi.pc_ipi,0) / 100) ) )
                                                        from pedido_venda_item pvi with (nolock) 
                                                          inner join pedido_venda pv with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda
                                                        where pv.cd_cliente = @cd_cliente and
                                                              isnull(pvi.qt_saldo_pedido_venda,0) > 0 and
                                                              pvi.dt_cancelamento_item is null and
                                                              pv.dt_fechamento_pedido  is not null
                                                        group by pv.cd_cliente),0),2) as vl_saldo_carteira_pedido

    from
      Cliente_Informacao_Credito i    with (nolock)
      left outer join Cliente c       with (nolock) on i.cd_cliente = c.cd_cliente 
      left outer join Estado u        with (nolock) on c.cd_estado = u.cd_estado
      left outer join Cidade d        with (nolock) on c.cd_cidade = d.cd_cidade    
      left outer join Vendedor cv     with (nolock) on cv.cd_vendedor = c.cd_vendedor
      left outer join Orgao_Credito o with (nolock) on o.cd_orgao_credito = i.cd_orgao_credito
      left outer join Suspensao_Credito sc with (nolock) on sc.cd_suspensao_credito=i.cd_suspensao_credito
      left outer join Tipo_Mercado tm with (nolock) on tm.cd_tipo_mercado = c.cd_tipo_mercado
      left outer join Motivo_Liberacao_Credito ml with (nolock) on ml.cd_motivo_liberacao = i.cd_motivo_liberacao
      left outer join Tipo_Pessoa tp  with (nolock) on tp.cd_tipo_pessoa = c.cd_tipo_pessoa
    where
      c.cd_cliente = @cd_cliente 
  end
else
  return

