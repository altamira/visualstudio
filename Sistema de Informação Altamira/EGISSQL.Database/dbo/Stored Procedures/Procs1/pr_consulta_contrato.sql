
CREATE PROCEDURE pr_consulta_contrato
@ic_parametro      integer,
@nm_contrato_carac varchar(20),
@dt_inicial datetime,
@dt_final datetime


AS

-------------------------------------------------------------------------------------------
  if @ic_parametro = 1 --Consulta por Data
-------------------------------------------------------------------------------------------
  begin
    select
      cc.cd_contrato,
      cc.nm_contrato_carac,
      cc.dt_contrato,
      case when isnull(cc.vl_divida_contrato,0)=0
            then 
               ( select sum(isnull(vl_produto,0)) from Produto_Contrato where cd_contrato = cc.cd_contrato )
            else 
               cc.vl_divida_contrato 
            end as vl_divida_contrato,
      c.nm_razao_social_cliente,
      ce.nm_cemiterio,
      ccc.dt_cancelamento_contrato,
      ccc.nm_motivo_cancelamento
    from
      Contrato_Concessao cc
    Left Join Cliente c
      on c.cd_cliente=cc.cd_cliente
    Left Join Cemiterio ce
      on ce.cd_cemiterio=cc.cd_cemiterio
    left join Contrato_Concessao_Cancelado ccc on ccc.cd_contrato = cc.cd_contrato

    where 
      dt_contrato between @dt_inicial and @dt_final
    order by cc.cd_contrato
  end
-------------------------------------------------------------------------------------------
  else if @ic_parametro = 2 --Consulta Somente contrato com o no. informado
-------------------------------------------------------------------------------------------
  begin
    select
      cc.cd_contrato,
      cc.nm_contrato_carac,
      cc.dt_contrato,
      case when isnull(cc.vl_divida_contrato,0)=0
            then 
               ( select sum(isnull(vl_produto,0)) from Produto_Contrato where cd_contrato = cc.cd_contrato )
            else 
               cc.vl_divida_contrato 
            end as vl_divida_contrato,
      c.nm_razao_social_cliente,
      ce.nm_cemiterio,
      ccc.dt_cancelamento_contrato,
      ccc.nm_motivo_cancelamento

    from
      Contrato_Concessao cc
    Left Join Cliente c
      on c.cd_cliente=cc.cd_cliente
    Left Join Cemiterio ce
      on ce.cd_cemiterio=cc.cd_cemiterio
    left join Contrato_Concessao_Cancelado ccc on ccc.cd_contrato = cc.cd_contrato
    where 
      nm_contrato_carac like @nm_contrato_carac+'%'
    order by cc.cd_contrato  end

-------------------------------------------------------------------------------------------
  else if @ic_parametro = 3 --Consulta Todos contrato
-------------------------------------------------------------------------------------------
  begin
    select
      cc.cd_contrato,
      cc.nm_contrato_carac,
      cc.dt_contrato,
      cc.vl_divida_contrato,
      c.nm_razao_social_cliente,
      ce.nm_cemiterio
    from
      Contrato_Concessao cc
    Left Join Cliente c
      on c.cd_cliente=cc.cd_cliente
    Left Join Cemiterio ce
      on ce.cd_cemiterio=cc.cd_cemiterio
    left join Contrato_Concessao_Cancelado ccc on ccc.cd_contrato = cc.cd_contrato
    order by cc.cd_contrato  end

-------------------------------------------------------------------------------------------
  else if @ic_parametro = 4 --Abre a consulta mas não traz nenhum contrato
-------------------------------------------------------------------------------------------
  begin
    select
      cc.cd_contrato,
      cc.nm_contrato_carac,
      cc.dt_contrato,
      cc.vl_divida_contrato,
      c.nm_razao_social_cliente,
      ce.nm_cemiterio,
      ccc.dt_cancelamento_contrato,
      ccc.nm_motivo_cancelamento

    from
      (select * from Contrato_Concessao cc where 1=2) as cc
    Left Join Cliente c
      on c.cd_cliente=cc.cd_cliente
    Left Join Cemiterio ce
      on ce.cd_cemiterio=cc.cd_cemiterio
    left join Contrato_Concessao_Cancelado ccc on ccc.cd_contrato = cc.cd_contrato
  end

-- =============================================  
-- Testando a procedure  
-- =============================================  
