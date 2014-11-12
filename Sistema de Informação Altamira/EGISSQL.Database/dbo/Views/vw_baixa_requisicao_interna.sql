
CREATE VIEW vw_baixa_requisicao_interna
------------------------------------------------------------------------------------
--sp_helptext vw_documentacao_padrao
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2011
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Mostra a Soma das Baixas das Requisições Internas
--
--Data                  : 26.01.2011
--Atualização           : 
--
------------------------------------------------------------------------------------
as


    select 
      rb.cd_requisicao_interna,
      rb.cd_item_req_interna,
      sum ( isnull(rb.qt_baixa_requisicao,0)) as qt_baixa_requisicao,
      max(dt_baixa_requisicao)                as dt_baixa_requisicao

    from
      requisicao_interna_baixa rb
    group by
      rb.cd_requisicao_interna,
      rb.cd_item_req_interna
     
 
