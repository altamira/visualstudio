
--pr_consulta_viagens
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Danilo Zapparoli Sanches Campoi
--Banco de Dados: EgisSQL
--Objetivo      : Consulta  de despesas por viagens,frota e motorista
-- 
--Data          : 06/03/2006
--Atualizado    : 08/05/2006 - Márcio Rodrigues - Inserio Parametro 5 (Consulta por qualquer parametro passado)
---------------------------------------------------



CREATE PROCEDURE pr_consulta_viagens
@dt_inicial DateTime,
@dt_final   DateTime,
@cd_motorista int = 0,
@cd_frota     int = 0,
@cd_despesa   int = 0,
@cd_viagem    int = 0
as
    select  
		a.cd_viagem as numeroviagem,
      a.cd_frota  as frota,
      c.nm_veiculo as Veiculo,
      g.nm_motorista as Motorista,
      a.ic_quinzena as Quinzena,  
      d.nm_local_deslocamento as Origem,
      e.nm_local_deslocamento as Destino,
      a.qt_entregas as QtdEntregas,
      a.qt_veiculos as QtdVeiculos,
      f.nm_despesa_viagem as Despesa ,
      isnull(b.vl_debito_despesa,0) as VlDebitoDesp, 
      isnull(b.vl_credito_reembolso,0) as VlCreditoReembolso,                                                             
		(isnull(b.vl_credito_reembolso,0) - isnull(b.vl_debito_despesa,0) ) as vl_liquido
    from remessa_viagem a
    	left outer join remessa_viagem_despesa     b on a.cd_remessa_viagem      = b.cd_remessa_viagem
    	left outer join veiculo                    c on c.cd_veiculo             = a.cd_veiculo
    	left outer join local_deslocamento         e on e.cd_local_deslocamento  = a.cd_local_chegada
    	left outer join local_deslocamento         d on d.cd_local_deslocamento  = a.cd_local_deslocamento       
    	left outer join tipo_despesa_viagem        f on f.cd_despesa_viagem      = b.cd_tipo_despesa_viagem
    	left outer join motorista                  g on g.cd_motorista           = a.cd_motorista  
    where 
    	(dbo.fn_data(a.dt_previsao_saida)  between dbo.fn_data(@dt_inicial) and dbo.fn_data(@dt_final)) and 
    	a.cd_motorista = (case when @cd_motorista = 0 then a.cd_motorista else @cd_motorista end) and 
    	a.cd_frota     = (case when @cd_frota = 0 then a.cd_frota else @cd_frota end) and
    	b.cd_tipo_despesa_viagem = (case when @cd_despesa = 0 then b.cd_tipo_despesa_viagem else @cd_despesa end)	and	
    	a.cd_viagem = (case when @cd_viagem = 0 then a.cd_viagem else @cd_viagem end)		

-- selec
-- select * from remessa_viagem
-- select * from local_deslocamento
-- select * from tipo_despesa_viagem 
