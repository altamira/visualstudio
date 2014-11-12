CREATE  PROCEDURE pr_controle_guia_remessa
------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2005
--Stored Procedure	: Microsoft SQL Server      
--Autor(es)		: Daniel Carrasco Neto
--Banco de Dados	: EGISSQL
--Objetivo		: Procedure com o Controle das GUias de Remessa
--Data			: 19/01/2005
-- 04/03/2005 - Modificado forma de cálculo do Pedido de Venda - Daniel C. Neto.
-- 08/03/2005 - Acerto no parâmetro 7 - Daniel C. Neto.
------------------------------------------------------------------------------------------

  @dt_inicial datetime,
  @dt_final datetime,
  @ic_parametro int,
  @cd_remessa_viagem int = 0,
  @cd_pedido_venda int = 0,
  @cd_usuario int = 0,
  @cd_nota_saida int = 0
AS

  -- variáveis locais
  declare @cd_parcela int
  declare @vl_parcela decimal(25,2)
  declare @nm_obs_parc varchar(40)
  declare @dt_parcela datetime
  declare @dt_remessa datetime
  declare @cd_plano_financeiro int
  declare @cd_tipo_conta int
  declare @cd_ident_parc varchar(25)
  declare @nm_fantasia varchar(30)
  declare @cd_documento int

    declare @cd_identificacao varchar(80)
    declare @cd_favorecido int
    declare @nm_observacao varchar(80)
    declare @Tabela varchar(50)


------------------------------------------------------------------------
if @ic_parametro = 1 -- Seleção de Pedidos para a Guia de Remesssa
------------------------------------------------------------------------
begin

  SELECT distinct
    0 as Sel,
    pv.cd_pedido_venda, 
    c.nm_fantasia_cliente, 
    nsi.cd_nota_saida,
    cid.nm_cidade, 
    pv.vl_total_pedido_venda + IsNull( (select top 1 ns.vl_icms_subst 
                                        from nota_saida ns left outer join 
                                             nota_saida_item nsi on ns.cd_nota_saida = nsi.cd_nota_saida 
                                        where nsi.cd_pedido_venda = pvi.cd_pedido_venda),0) as vl_total_pedido_venda, 

    ( case when IsNull(tp.ic_sem_valor_remessa,'N') = 'S' then 0
      else pv.vl_total_pedido_venda + 
                               IsNull( (select top 1 ns.vl_icms_subst 
                                        from nota_saida ns left outer join 
                                             nota_saida_item nsi on ns.cd_nota_saida = nsi.cd_nota_saida 
                                        where nsi.cd_pedido_venda = pvi.cd_pedido_venda),0) end ) as vl_total_somar, 
    pv.qt_bruto_pedido_venda,
    pv.cd_condicao_pagamento,
    IsNull(tp.ic_sem_valor_remessa,'N') as ic_sem_valor_remessa
  FROM         
    Pedido_Venda pv inner join
    Pedido_Venda_Item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda left outer join
    Cliente c ON pv.cd_cliente = c.cd_cliente left outer join
    Cidade cid ON c.cd_pais = cid.cd_pais and 
                  c.cd_estado = cid.cd_estado and
                  c.cd_cidade = cid.cd_cidade left outer join
    Tipo_Pedido tp on tp.cd_tipo_pedido = pv.cd_tipo_pedido inner join
    Nota_Saida_Item nsi on nsi.cd_pedido_venda = pvi.cd_pedido_venda and
                           nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda                        
  where
    pv.dt_pedido_venda between @dt_inicial and @dt_final and
   IsNull(( select sum(x.qt_item_pedido_venda)
            from
              REMESSA_VIAGEM_ITEM_PEDIDO x
            where
              x.cd_pedido_venda = pv.cd_pedido_venda and
              x.cd_item_pedido_venda = pvi.cd_item_pedido_venda ),0) < 

   IsNull(( select x.qt_item_pedido_venda
            from
              Pedido_Venda_Item x
            where
              x.cd_pedido_venda = pv.cd_pedido_venda and
              x.cd_item_pedido_venda = pvi.cd_item_pedido_venda ),0) and
   pvi.dt_cancelamento_item is null and
   nsi.dt_cancel_item_nota_saida is null

end

else 
------------------------------------------------------------------------
if @ic_parametro = 2 -- Trazer todas as guias em aberto no período
------------------------------------------------------------------------
begin

SELECT     
  rv.CD_REMESSA_VIAGEM, 
  rv.DT_REMESSA_VIAGEM, 
  rv.CD_TRANSPORTADORA,
  t.nm_fantasia as nm_fantasia_transportadora,
  rv.dt_previsao_chegada as DtPrev,
  cast(null as float) as vl_remessa,
  cast(null as float) as vl_remessa_somar,
  case when exists ( select 'x' from Remessa_Viagem_Parcela x where x.cd_remessa_viagem = rv.cd_remessa_viagem )
       then 'S' else 'N' end as ic_conta_pagar,
  case when exists ( select 'x' from Remessa_Viagem_Pedido_Parcela x where x.cd_remessa_viagem = rv.cd_remessa_viagem )
       then 'S' else 'N' end as ic_conta_receber,
  rv.qt_km_final

into #Teste
FROM         
  Remessa_Viagem rv left outer join
  Transportadora t ON rv.CD_TRANSPORTADORA = t.cd_transportadora
where
   rv.DT_REMESSA_VIAGEM between @dt_inicial and @dt_final and
   IsNull(rv.ic_fechada_remessa,'N') = 'N' 

select * into #Teste2 from #Teste

declare @cd_guia_remessa int

while exists ( select 'x' from #Teste )
begin

  set @cd_guia_remessa = ( select top 1 cd_remessa_viagem from #Teste )

SELECT     
  dbo.fn_vl_total_pedido_remessa(rvp.cd_remessa_viagem, rvp.cd_pedido_venda,'R') as vl_total_somar
into #Teste3
FROM         
  REMESSA_VIAGEM_PEDIDO rvp left outer join
  Pedido_Venda pv ON rvp.CD_PEDIDO_VENDA = pv.cd_pedido_venda left outer join
  Cliente c ON pv.cd_cliente = c.cd_cliente left outer join
  Cidade cid ON c.cd_pais = cid.cd_pais and
                          c.cd_estado = cid.cd_estado and
                          c.cd_cidade = cid.cd_cidade left outer join
  Tipo_Pedido tp on tp.cd_tipo_pedido = pv.cd_tipo_pedido
where
   rvp.cd_remessa_viagem = @cd_guia_remessa

update #Teste2
set vl_remessa = ( select sum(vl_total_somar) from #Teste3 ),
    vl_remessa_somar = ( select sum(vl_total_somar) from #Teste3)
where cd_remessa_viagem = @cd_guia_remessa

drop table #Teste3

delete from #Teste where cd_remessa_viagem = @cd_guia_remessa

end

select * from #Teste2

end

---------------------------------------------------------------------------------
else if @ic_parametro = 3 -- Trazer as despesas de uma determinada remessa
---------------------------------------------------------------------------------
begin

  select
    *
  from
    REMESSA_VIAGEM_DESPESA
  where
    cd_remessa_viagem = @cd_remessa_viagem

end

-------------------------------------------------------------------------------------------------------
else if @ic_parametro = 4 -- Trazer todos os itens do pedido de venda ainda não gravados na Remessa
-------------------------------------------------------------------------------------------------------
begin

SELECT     
  rvp.cd_remessa_viagem, 
  rvp.cd_pedido_venda,
  pv.cd_item_pedido_venda,
  IsNull(( select pv.qt_item_pedido_venda
           from
             Pedido_Venda_Item x
           where
             x.cd_pedido_venda = rvp.cd_pedido_venda and
             x.cd_item_pedido_venda = pv.cd_item_pedido_venda ),0) -
  IsNull(( select sum(x.qt_item_pedido_venda)
           from
             REMESSA_VIAGEM_ITEM_PEDIDO x
           where
             x.cd_pedido_venda = rvp.cd_pedido_venda and
             x.cd_item_pedido_venda = pv.cd_item_pedido_venda ),0)

 as qt_saldo_pedido_venda,
 pv.vl_unitario_item_pedido, 
 ( case when
      ( select t.ic_sem_valor_remessa 
        from 
          Pedido_Venda x left outer join
          tipo_pedido t on x.cd_tipo_pedido = t.cd_tipo_pedido
        where
          x.cd_pedido_venda = pv.cd_pedido_venda ) = 'S' then 0
    else pv.vl_unitario_item_pedido end ) as vl_unitario_somar, 

  pv.qt_bruto_item_pedido, 
  pv.pc_ipi, 
  pv.pc_icms, 
  p.nm_produto,
  dbo.fn_mascara_produto(pv.cd_produto) as cd_mascara_produto


FROM         
  REMESSA_VIAGEM_PEDIDO rvp inner join
  Pedido_Venda_Item pv ON rvp.CD_PEDIDO_VENDA = pv.cd_pedido_venda and
                          not exists ( select 'x' from REMESSA_VIAGEM_ITEM_PEDIDO x
                                       where x.cd_remessa_viagem = rvp.cd_remessa_viagem and
                                             x.cd_pedido_venda = pv.cd_pedido_venda and
                                             x.cd_item_pedido_venda = pv.cd_item_pedido_venda ) inner join
  Nota_Saida_item nsi on nsi.cd_pedido_venda = pv.cd_pedido_venda and
                         nsi.cd_item_pedido_venda = pv.cd_item_pedido_venda left outer join
  Produto p ON pv.cd_produto = p.cd_produto

where
   rvp.cd_remessa_viagem = @cd_remessa_viagem and
   IsNull(( select sum(x.qt_item_pedido_venda)
            from
              REMESSA_VIAGEM_ITEM_PEDIDO x
            where
              x.cd_pedido_venda = rvp.cd_pedido_venda and
              x.cd_item_pedido_venda = pv.cd_item_pedido_venda ),0) < 

   IsNull(( select x.qt_item_pedido_venda
            from
              Pedido_Venda_Item x
            where
              x.cd_pedido_venda = rvp.cd_pedido_venda and
              x.cd_item_pedido_venda = pv.cd_item_pedido_venda ),0) and
   rvp.cd_pedido_venda = ( case when @cd_pedido_venda = 0 then
                             rvp.cd_pedido_venda else 
                             @cd_pedido_venda end ) and
   nsi.cd_nota_saida = ( case when @cd_nota_saida = 0 then
                             nsi.cd_nota_saida else 
                             @cd_nota_saida end ) and

   pv.dt_cancelamento_item is null and
   nsi.dt_cancel_item_nota_saida is null
                            





end

-----------------------------------------------------------------
else if @ic_parametro = 5 -- Gerar Documentos a Pagar pela Remessa.
-----------------------------------------------------------------
begin
 
    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Pagar' as varchar(50))

    -- Tabela temporária com as informações da Parcela  
    select 
      rp.cd_remessa_viagem,
      rp.cd_parcela_remessa_viagem,
      rp.cd_identificacao_parcela,
      rp.dt_vencimento_remessa,
      rp.vl_parcela_remessa,
      rp.nm_parcela_remessa,
      t.cd_empresa_diversa,
      r.dt_remessa_viagem,
      tcp.cd_plano_financeiro as cd_plano_financeiro,
      t.cd_tipo_conta_pagar as cd_tipo_conta_pagar,
      rp.cd_documento_pagar
    into
      #Remessa_Parcela
    from
       Remessa_Viagem_Parcela rp left outer join
       Remessa_Viagem r on r.cd_remessa_viagem = rp.cd_remessa_viagem left outer join
       Transportadora t on t.cd_transportadora = r.cd_transportadora left outer join
       Tipo_Conta_Pagar tcp on tcp.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar

    where
      r.cd_remessa_viagem = @cd_remessa_viagem

    select
      @nm_fantasia = nm_fantasia
    from
      Remessa_Viagem r left outer join
      Transportadora t on t.cd_transportadora = r.cd_transportadora
    where
      r.cd_remessa_viagem = @cd_remessa_viagem



    -- verifica se as duplicatas geradas anteriormente já foram pagas
    if exists (select top 1 'x' from documento_pagar_pagamento where
               cd_documento_pagar in (select cd_documento_pagar from #Remessa_Parcela))
      raiserror('Já foi efetuado pagamento de uma ou mais parcelas geradas anteriormente!
                 Não foi possível gerar as parcelas novamente.', 16,1)
    else 
    begin

 
      delete from 
        Documento_Pagar 
      where 
        cd_documento_pagar in (select cd_documento_pagar from #Remessa_Parcela) 

    end   
    -- leitura das parcelas e geração das duplicatas
    while exists(select cd_parcela_remessa_viagem from #Remessa_Parcela)
      begin
       
        -- Código Único    
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento output

        select
          top 1
          @cd_parcela = cd_parcela_remessa_viagem,
          @vl_parcela = cast(str(vl_parcela_remessa,25,2) as decimal(25,2)),
          @nm_obs_parc = nm_parcela_remessa,
          @dt_remessa  = dt_remessa_viagem,
          @dt_parcela = dt_vencimento_remessa,
          @cd_ident_parc  = cd_identificacao_parcela,
          @cd_tipo_conta      = cd_tipo_conta_pagar,
          @cd_plano_financeiro      = cd_plano_financeiro,
          @cd_favorecido        = cd_empresa_diversa
        from
          #Remessa_Parcela

        insert into Documento_Pagar (
          cd_documento_pagar,
          cd_identificacao_document,
          dt_emissao_documento_paga,
          dt_vencimento_documento,
          vl_documento_pagar,
          cd_nota_fiscal_entrada,
          cd_serie_nota_fiscal_entr,
          cd_serie_nota_fiscal,
          nm_observacao_documento,
          vl_saldo_documento_pagar,
          cd_tipo_documento,
          cd_tipo_conta_pagar,
          cd_empresa_diversa,
          cd_usuario,
          dt_usuario,
          cd_pedido_compra,
          cd_plano_financeiro,
          nm_fantasia_fornecedor )
        values (
          @cd_documento,
          @cd_ident_parc,
          @dt_remessa,
          @dt_parcela,
          @vl_parcela,
          0,
          '',
          0,
          @nm_obs_parc,
          @vl_parcela,
          8,  -- Vindo pelo Pedido de Venda
          @cd_tipo_conta,
          @cd_favorecido,
          @cd_usuario,
          getDate(),
          0,
          @cd_plano_financeiro,
          '' )

          exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento, 'D'   

          update 
            Remessa_Viagem_Parcela
          set 
            cd_documento_pagar = @cd_documento
          where
            cd_remessa_viagem = @cd_remessa_viagem and
            cd_parcela_remessa_viagem = @cd_parcela
           
          delete from
            #Remessa_Parcela
          where
            cd_parcela_remessa_viagem = @cd_parcela
            
      end 



end

------------------------------------------------------------------------------
else if @ic_parametro = 6 -- Gerar Documentos a Receber pela Remessa.
------------------------------------------------------------------------------
begin

    declare @cd_tipo_doc int 
    declare @cd_vendedor int
    declare @ic_credito_icms_nota char(1)
    declare @dt_emissao datetime
    declare @vl_desconto float
    declare @cd_portador int
    declare @cd_tipo_cobranca int

    set Dateformat dmy

    -- Na geração automática excluir as duplicatas já existentes que foram
    -- geradas anteriormente e que por qualque motivo tiveram de ser 
    -- geradas novamente
    delete
      Documento_Receber
    where
      cd_documento_receber in ( select cd_documento_receber 
                                from Remessa_Viagem_Pedido_Parcela 
                                where cd_remessa_viagem = @cd_remessa_viagem ) and
      vl_saldo_documento <> 0
    
    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(50))
  
    select
      rvp.cd_remessa_viagem,
      rvp.cd_parcela_recebimento,
      IsNull(rvp.vl_parcela_recebimento,0) -  
      IsNull(rvp.vl_desconto_recebimento,0) as 'vl_parcela',     
      IsNull(rvp.vl_desconto_recebimento,0) as 'vl_desconto',
      rvp.dt_vencimento_Parcela,
      1 as cd_tipo_destinatario,     
      pv.cd_pedido_venda,
      pv.cd_cliente,
      pv.cd_vendedor,
      pv.dt_pedido_venda,
      rvp.cd_identificacao_parcela,
      IDENTITY(int, 1, 1) AS Inc,
      pc.cd_plano_financeiro,
      pv.ic_credito_icms_pedido,
      rvp.cd_tipo_pagamento,
      rvp.cd_tipo_documento

    into
      #Remessa_Pedido_Parcela
    from
      Remessa_Viagem_Pedido_Parcela rvp left outer join
      Pedido_Venda         pv  on rvp.cd_pedido_venda = pv.cd_pedido_venda left outer join
      Parametro_Comercial  pc  on pc.cd_empresa = dbo.fn_empresa() left outer join
      Tipo_Pedido tp on tp.cd_tipo_pedido = pv.cd_tipo_pedido
    where
      rvp.cd_remessa_viagem = @cd_remessa_viagem and
      pv.cd_pedido_venda is not null and
      pv.dt_cancelamento_pedido is null and
      ( IsNull(rvp.vl_parcela_recebimento,0) - IsNull(rvp.vl_desconto_recebimento,0) ) > 0 and
      IsNull(tp.ic_sem_valor_remessa,'N') = 'N'
    order by
      rvp.cd_remessa_viagem,
      rvp.cd_parcela_recebimento

    -- Pegando Portador.
    select
      @cd_portador       = cd_portador,
      @cd_tipo_cobranca  = cd_tipo_cobranca
    from  
      Parametro_Financeiro
    where
      cd_empresa = dbo.fn_empresa()


    while exists(select cd_pedido_venda from #Remessa_Pedido_Parcela)
    begin
     
        -- campos da tabela de parcelas
        select
          top 1
          @cd_remessa_viagem        = cd_remessa_viagem,
          @cd_parcela               = cd_parcela_recebimento,
          @vl_parcela               = vl_parcela,
          @vl_desconto              = vl_desconto,
          @dt_parcela               = convert(datetime, dt_vencimento_Parcela ,103),
          @cd_favorecido            = cd_cliente,
          @cd_pedido_venda          = cd_pedido_venda,
          @cd_plano_financeiro      = cd_plano_financeiro,
    	    @cd_ident_parc            = cd_identificacao_parcela,
          @cd_vendedor		          = cd_vendedor,
          @ic_credito_icms_nota     = ic_credito_icms_pedido,
          @cd_tipo_doc              = cd_tipo_documento
        from
          #Remessa_Pedido_Parcela
        order by  
          cd_remessa_viagem,
          cd_parcela_recebimento

        -- campo chave utilizando a tabela de códigos
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento output

        while exists(Select top 1 'x' from documento_receber where cd_documento_receber = @cd_documento)
          begin
      	    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento output	     
      	    -- limpeza da tabela de código
      	    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento, 'D'
      	  end

        set @dt_emissao = convert(datetime, cast(GetDate() as integer),103)

        if @dt_emissao > @dt_parcela
          set @dt_parcela = @dt_emissao

  
        -- montagem da identificação do documento
        exec pr_documento_receber 
           2, 
           null, 
           null, 
           @cd_documento, 
           @cd_ident_parc,
           @dt_emissao, -- Data de emissão vai ser hoje mesmo.
           @dt_parcela, 
           @dt_parcela, 
           @vl_parcela,
           @vl_parcela, 
           null, 
           null, 
           0, 
           null, 
           'Geração Automática Pela Remessa.', 
           'N', 
           null,
           null, 
           null, 
           @cd_portador, 
           @cd_tipo_cobranca, 
           @cd_favorecido, 
           @cd_tipo_doc, 
           @cd_pedido_venda, 
           null, 
           @cd_vendedor,
           null, 
           0, 
           'A', 
           null, 
           @cd_plano_financeiro, 
           @cd_usuario, 
           '',
           1,
           @vl_desconto,
           0,
           null, 
           @ic_credito_icms_nota --Define que o pedido será pago com o crédito de ICMS

       update Remessa_Viagem_Pedido_Parcela
       set cd_documento_receber = @cd_documento
       where
         cd_remessa_viagem = @cd_remessa_viagem and
         cd_Pedido_venda = @cd_pedido_venda and
         cd_parcela_recebimento = @cd_parcela
        
        -- limpesa da tabela de código
        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento, 'D'

      
        -- exclusão do registro usado

        delete 
          #Remessa_Pedido_Parcela
        where
          cd_pedido_venda = @cd_pedido_venda and
          cd_parcela_recebimento = @cd_parcela
  
      end

     drop table #Remessa_Pedido_Parcela
end

---------------------------------------------------------------------------------
else if @ic_parametro = 7 -- Calcular fundo de caixa do relatório de remessa.
--------------------------------------------------------------------------------
begin

SELECT     
  (case when rvpp.dt_vencimento_parcela = rv.dt_remessa_viagem then
     'Total a vista' else 'Total a Prazo' end) as 'ic_vencimento',
  rvp.CD_PEDIDO_VENDA, 
  tp.nm_tipo_documento as nm_tipo_pagamento, 
  rvpp.CD_IDENTIFICACAO_PARCELA, 
  rvpp.VL_PARCELA_RECEBIMENTO - IsNull(vl_desconto_recebimento,0) as vl_parcela_recebimento,

  ( case when IsNull(tpe.ic_sem_valor_remessa,'N') = 'S' then 0 else
    rvpp.VL_PARCELA_RECEBIMENTO - IsNull(vl_desconto_recebimento,0) end ) as vl_parcela_somar,

  rvpp.dt_vencimento_parcela
into #Resumo
FROM         
  REMESSA_VIAGEM rv inner join
  REMESSA_VIAGEM_PEDIDO rvp on rv.cd_remessa_viagem = rvp.cd_remessa_viagem left outer join
  REMESSA_VIAGEM_PEDIDO_PARCELA rvpp ON 
             rvp.CD_REMESSA_VIAGEM = rvpp.CD_REMESSA_VIAGEM AND 
             rvp.CD_PEDIDO_VENDA = rvpp.CD_PEDIDO_VENDA left outer join
  Tipo_Documento tp ON rvpp.CD_TIPO_DOCUMENTO = tp.cd_tipo_documento left outer join
  Pedido_Venda pv on pv.cd_pedido_venda = rvp.cd_pedido_venda left outer join
  Tipo_pedido tpe on tpe.cd_tipo_pedido = pv.cd_tipo_pedido
where
  rvp.cd_remessa_viagem = @cd_remessa_viagem
order by
  rvp.cd_pedido_venda,
  tp.nm_tipo_documento

select
  ic_vencimento,
  nm_tipo_pagamento,
  sum(vl_parcela_recebimento) as vl_total,
  sum(vl_parcela_somar) as vl_total_somar
from
  #Resumo
group by
  ic_vencimento,
  nm_tipo_pagamento



end




