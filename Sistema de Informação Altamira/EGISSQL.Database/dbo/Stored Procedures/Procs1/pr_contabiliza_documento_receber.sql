
CREATE PROCEDURE pr_contabiliza_documento_receber
------------------------------------------------------------------------------ 
--GBS - Global Business Solution              2002 
------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es)        : Carlos Cardoso Fernandes.
--Banco de Dados   : EGISSQL 
--Objetivo         : Contabilização de Documentos a Receber.
--Data             : ??/01/2003 
--Atualizado       : 17/01/2003 - Daniel C. Neto - Deixado no padrão GBS.
--                   27.02.2003 - Revisão Geral
--                   22/04/2003 - Incluido filtro pelo 'vl_desconto_documento'
--                                para validação de Valores conforme pedido pelo Cliente(POLIMOLD) - Duela
------------------------------------------------------------------------------ 

@dt_inicial        datetime,
@dt_final          datetime,
@cd_portador       int,
@ic_contabilizacao char(1)

as

declare @ic_razao_cliente_empresa char(1)
set @ic_razao_cliente_empresa = 'N'

  select 
    @ic_razao_cliente_empresa = isnull(ic_razao_cliente_empresa,'N')
  from
    Parametro_Financeiro
  where
    cd_empresa = dbo.fn_empresa() -- funcao que pega a empresa automaticamente.

  --Checa se o código contábil é por cliente

  if @ic_razao_cliente_empresa = 'S'
  begin

    -- Agrupa todos os lançamentos em um único registro 
    select
       'z'                                           as 'Documento',
       null                                          as 'Cliente',
       null                                          as 'DataContabilizacao',
       null                                          as 'Debito',
      (max(isnull(cd_conta_reduzido,0)))             as 'Credito',
       sum(dc.vl_contab_documento)                   as 'Valor',
       null                                          as 'CodHis',
       null                                          as 'Historico',
       null 					     as 'HistoricoContabil',
       null                                          as 'CodPortador',
       null                                          as 'Portador'
    -------
    into #TotalContabilCliente
    -------
    from
       Documento_Receber_Contabil dc
    left outer join Documento_Receber d on
      dc.cd_documento_receber = d.cd_documento_receber
    left outer join Cliente c on
      d.cd_cliente = c.cd_cliente
   left outer join Plano_Conta pc on
     pc.cd_conta= dc.cd_conta_credito 
   left outer join Historico_Contabil h on
      dc.cd_historico_contabil = h.cd_historico_contabil
    left outer join Lancamento_Padrao lp on
      dc.cd_lancamento_padrao = lp.cd_lancamento_padrao
    left outer join Tipo_Contabilizacao t on
      lp.cd_tipo_contabilizacao = t.cd_tipo_contabilizacao
    left outer join Portador p on
      d.cd_portador = p.cd_portador
 
    where dc.dt_contab_documento between @dt_inicial and @dt_final and
         (t.nm_atributo = 'cd_cliente' or t.nm_atributo ='dt_devolucao_documento' or
          t.nm_atributo='vl_desconto_documento') and
         (@cd_portador = 0 or
          d.cd_portador = @cd_portador)

  end

  if @ic_razao_cliente_empresa = 'S'
    begin
-----------------------
--Documentos à Receber
-----------------------
    select
       d.cd_identificacao                      as 'Documento',
       c.nm_fantasia_cliente                   as 'Cliente',
       dc.dt_contab_documento                  as 'DataContabilizacao',
     ( select IsNull(cd_conta_reduzido,0)
       from Plano_Conta 
       where dc.cd_conta_debito = cd_conta )   as 'Debito',
     ( select IsNull(cd_conta_reduzido,0)
       from Plano_Conta 
       where dc.cd_conta_credito = cd_conta )  as 'Credito',
       dc.vl_contab_documento                  as 'Valor',
       dc.cd_historico_contabil                as 'CodHis',
       dc.nm_historico_documento               as 'Historico',
       h.nm_historico_contabil                 as 'HistoricoContabil',
       d.cd_portador                           as 'CodPortador',
       cast(d.cd_portador as varchar)+' - '+
            p.sg_portador                      as 'Portador'
    -------
    into #ContabilRazaoSim
    -------               
    from
       Documento_Receber_Contabil dc

    inner join Documento_Receber d on
    dc.cd_documento_receber = d.cd_documento_receber

    inner join Cliente c on
    d.cd_cliente = c.cd_cliente

    left join Historico_Contabil h on
    dc.cd_historico_contabil = h.cd_historico_contabil

    inner join Lancamento_Padrao lp on
    dc.cd_lancamento_padrao = lp.cd_lancamento_padrao

    left outer join Tipo_Contabilizacao t on
    lp.cd_tipo_contabilizacao = t.cd_tipo_contabilizacao

    left outer join Portador p on
    d.cd_portador = p.cd_portador

   where
      dc.dt_contab_documento between @dt_inicial and @dt_final and
      isnull(t.nm_atributo,' ') <> 'cd_cliente' and
     (@cd_portador = 0 or
      d.cd_portador = @cd_portador) 
   order by d.cd_identificacao

-----------------------
--Notas de Débito
-----------------------
    select
       nd.cd_nota_debito                      as 'Documento',
       c.nm_fantasia_cliente                   as 'Cliente',
       ndc.dt_contab_documento                  as 'DataContabilizacao',
     ( select IsNull(cd_conta_reduzido,0)
       from Plano_Conta 
       where ndc.cd_conta_debito = cd_conta )   as 'Debito',
     ( select IsNull(cd_conta_reduzido,0)
       from Plano_Conta 
       where ndc.cd_conta_credito = cd_conta )  as 'Credito',
       ndc.vl_contab_documento                  as 'Valor',
       ndc.cd_historico_contabil                as 'CodHis',
       ndc.nm_historico_documento               as 'Historico',
       h.nm_historico_contabil                 as 'HistoricoContabil',
       null                                    as 'CodPortador',
       null                                    as 'Portador'
    -------
    into #NotaDebitoContabilRazaoSim
    -------               
    from
       Nota_Debito_Contabil ndc
    inner join Nota_Debito nd on
      ndc.cd_nota_debito = nd.cd_nota_debito
    inner join Cliente c on
      c.cd_cliente = nd.cd_cliente
    left join Historico_Contabil h on
      ndc.cd_historico_contabil = h.cd_historico_contabil
    inner join Lancamento_Padrao lp on
      ndc.cd_lancamento_padrao = lp.cd_lancamento_padrao
    left outer join Tipo_Contabilizacao t on
      lp.cd_tipo_contabilizacao = t.cd_tipo_contabilizacao
   where
      ndc.dt_contab_documento between @dt_inicial and @dt_final and
      isnull(t.nm_atributo,' ') <> 'cd_cliente' 
   order by nd.cd_nota_debito

   -- Grava como último registro o total do cliente
   insert into #ContabilRazaoSim
   select * from #NotaDebitoContabilRazaoSim

   insert into #ContabilRazaoSim
   select * from #TotalContabilCliente

   select * from #ContabilRazaoSim
   order by documento
   end

  else--

    begin
    select
       d.cd_identificacao                      as 'Documento',
       c.nm_fantasia_cliente                   as 'Cliente',
       dc.dt_contab_documento                  as 'DataContabilizacao',
     ( select IsNull(cd_conta_reduzido,0)
       from Plano_Conta 
       where dc.cd_conta_debito = cd_conta )   as 'Debito',
     ( select IsNull(cd_conta_reduzido,0)
       from Plano_Conta 
       where dc.cd_conta_credito = cd_conta )  as 'Credito',
       dc.vl_contab_documento                  as 'Valor',
       dc.cd_historico_contabil                as 'CodHis',
       dc.nm_historico_documento               as 'Historico',
       h.nm_historico_contabil                 as 'HistoricoContabil',
       d.cd_portador                           as 'CodPortador',
       cast(d.cd_portador as varchar)+' - '+
            p.sg_portador                      as 'Portador'

    from
       Documento_Receber_Contabil dc

    inner join Documento_Receber d on
    dc.cd_documento_receber = d.cd_documento_receber

    inner join Cliente c on
    d.cd_cliente = c.cd_cliente

    left join Historico_Contabil h on
    dc.cd_historico_contabil = h.cd_historico_contabil

    inner join Lancamento_Padrao lp on
    dc.cd_lancamento_padrao = lp.cd_lancamento_padrao

    left outer join Tipo_Contabilizacao t on
    lp.cd_tipo_contabilizacao = t.cd_tipo_contabilizacao

    left outer join Portador p on
    d.cd_portador = p.cd_portador 

   where
      dc.dt_contab_documento between @dt_inicial and @dt_final and
     (@cd_portador = 0 or
      d.cd_portador = @cd_portador) and
     (p.ic_contab_baixa_portador = @ic_contabilizacao or @ic_contabilizacao is null)
   order by d.cd_identificacao
   end

