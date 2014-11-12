

CREATE PROCEDURE pr_emitir_cheque_receber
--------------------------------------------------------------------------------------------------------------- 
--GBS - Global Business Solution              2002 
--------------------------------------------------------------------------------------------------------------- 
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es)        :   Daniel C. Neto 
--Banco de Dados   : EGISSQL 
--Objetivo         : Selecionar dados para a emissão do Cheque a Pagar.
--Data             : 31/03/2003
--Alterações       : 13.04.2007 - Verificação e Acertos Diversos - Carlos Fernandes
--                 : 23.04.2007 - Acerto do Valor Monetário do Cheque - Carlos Fernandes
----------------------------------------------------------------------------------------------------------------- 

@ic_parametro            int           = 1,
@cd_cheque_receber         varchar(8000) = '',
@vl_cheque_receber         float         = 0.00,
@vl_cheque_extenso       Varchar(200)  = '',
@dt_emissao_cheque_receber datetime,
@nm_favorecido           varchar(60)   = '',
@nm_filtro               varchar(500)  = ''

AS 

---------------------------------------------------------
if @ic_parametro = 1 -- Impressão Cheque Avulso
---------------------------------------------------------
begin

SELECT top 1
  '#('+ltrim(rtrim(cast(cast(@vl_cheque_receber as money) as varchar)))+')#' as 'Valor',
  replicate('.', 8) + '('+ltrim(rtrim(@vl_cheque_extenso))+')'               as 'ValorExtenso' ,
  day(@dt_emissao_cheque_receber)                                            as 'Dia',
  m.nm_mes                                                                   as 'Mes',
  year(@dt_emissao_cheque_receber)                                           as 'Ano',
  '('+ltrim(rtrim(@nm_favorecido))+')'                                       as 'Favorecido',
  cid.nm_cidade                                                              as 'Local'

FROM       cheque_receber p left outer join
           Mes m on m.cd_mes = month(@dt_emissao_cheque_receber) left outer join
           EGISADMIN.dbo.Empresa e on e.cd_empresa = dbo.fn_empresa() left outer join
           Cidade cid on cid.cd_pais = e.cd_pais and
                         cid.cd_estado = e.cd_estado and
                         cid.cd_cidade = e.cd_cidade
end

