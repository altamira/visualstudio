
-----------------------------------------------------------------------------------------
--pr_controle_prospeccao
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                                               2004
-----------------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Rafael M. Santiago
--                      : Carlos Cardoso Fernandes
--Banco de Dados        : EGISSQL
--Objetivo              : Consulta de Prospecções
--Data                  : 12/07/2004
--Atualizado            : 09/09/2004 - Alterado para buscar apenas o primeiro contato do cliente - ELIAS 
--                      : 10/09/2004 - Mostra Cliente Prospeccao mesmo sem Prospeccao - ELIAS
--                      : 11/09/2004 - Revisão e Acertos - Carlos
--		        : 15/09/2004 - Alterado para colocar mais parametros para nova tela de consulta - Rodolpho  
--                      : 27/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 15.03.2006 - Ajuste da SP duplicidade - Carlos Fernandes
--                                   - Mostrar somente a ação que tenha esteja com 'S' p/ Operação - Carlos Fernandes
--                        01/09/2006 - Inclusão de dois novos parâmetros e simplificação da escolha de filtro de datas.
--                                   - Daniel C. neto.
--------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE pr_controle_prospeccao
@Dt_inicio                 datetime ,
@Dt_Fim                    datetime ,
@cd_operador_telemarketing int,
@cd_campanha               int, 
@cd_regiao_venda           int ,
@cd_tipo_cliente           int ,
@cd_vendedor		         int  ,
@cd_fonte_informacao       int ,
@cd_ramo_atividade         int ,
@cd_status_prospeccao      int ,
@Dt_Retorno_Inicio         datetime ,
@Dt_Retorno_Fim            datetime,
@nm_fantasia_cliente       varchar(50) = '',
@qtd_registros             int = 0

AS

--select @dt_inicio
--select @dt_fim

declare @top int

if IsNull(@qtd_registros,0) = 0 
   set ROWCOUNT 10000
else
   set ROWCOUNT @qtd_registros


SELECT 
   p.dt_prospeccao,
  'N' as 'ic_atrasado',
	case when count(p.cd_prospeccao) > 0 then 'S' else 'N' end                 as 'ic_prospeccao',
	case when (isnull(p.dt_retorno_prospeccao, '') = '') then 'N' else 'S' end as 'ic_retorno',
	case when cast(convert(varchar,p.dt_retorno_prospeccao,101) as datetime) < 
                  cast(convert(varchar,getdate(),101) as datetime) 
        then 'S' else 'N' end                                                      as 'ic_retorno_atraso',
	case when (isnull(p.dt_apresentacao, '') = '') then 'N' else 'S' end       as 'ic_apresentacao',
	case when (isnull(p.dt_visita ,'') = '') then 'N' else 'S' end             as 'ic_visita',
	case when cast(convert(varchar,p.dt_visita,101) as datetime) < 
                  cast(convert(varchar,getdate(),101) as datetime) 
             then 'S' else 'N' end                                                 as 'ic_visita_atrasada',
	case when (isnull(p.dt_fechamento, '') = '') then 'N' else 'S' end         as 'ic_negocio',
	case when (isnull(p.dt_perda, '') = '') then 'N' else 'S' end              as 'ic_perda',
	case when (count(p.cd_prospeccao) >= 0) 
            and (isnull(p.dt_retorno_prospeccao,'') = '') 
            and (isnull(p.dt_apresentacao,'') ='' ) 
            and (isnull(p.dt_visita, '') = '') 
            and (isnull(p.dt_fechamento, '') = '') 
            and (isnull(p.dt_perda, '') = '') 
         then 'S' else 'N' end                                                     as 'ic_sem_informacao',
         p.dt_prospeccao,
  	cp.cd_cliente_prospeccao,
  	cp.nm_fantasia_cliente,
        --contato
  	(select top 1 x.nm_fantasia_contato from Cliente_Prospeccao_Contato x
     where x.cd_cliente_prospeccao = cp.cd_cliente_prospeccao
     order by x.cd_prospeccao_contato) as nm_fantasia_contato,
  	(select top 1 nm_cargo_contato from Cliente_Prospeccao_Contato x
     where x.cd_cliente_prospeccao = cp.cd_cliente_prospeccao
     order by cd_prospeccao_contato)  as nm_cargo_contato,

	isnull(acao.nm_acao_prospeccao,'')               as nm_acao_prospeccao ,
  	cd_ddd_cliente , 
  	cp.cd_fone_cliente,
  	cp.nm_email_cliente,
  	cp.nm_site_cliente,
  	v.nm_fantasia_vendedor,
  	cm.nm_campanha,
  	ot.nm_operador_telemarketing,
  	ci.nm_cidade,
   	p.dt_retorno_prospeccao,
  	es.nm_estado,
        isnull(sp.nm_status_prospeccao,'') as nm_status_prospeccao,
        p.nm_obs_prospeccao,
        conc.nm_concorrente

FROM
    Cliente_Prospeccao cp
    LEFT OUTER JOIN Prospeccao             p        ON cp.cd_cliente_prospeccao         = p.cd_cliente_prospeccao  --isnull(p.cd_cliente_prospeccao,cp.cd_cliente_prospeccao)
--    LEFT OUTER JOIN Cliente_Prospeccao_Campanha cpc on cpc.cd_cliente_prospeccao        = cp.cd_cliente_prospeccao and
--                                                       isnull(cpc.ic_ativa_campanha,'N')='S'                
                 
    LEFT OUTER JOIN Campanha_Cliente       c        ON c.cd_cliente                     = cp.cd_cliente
    LEFT OUTER JOIN Campanha              cm        ON cm.cd_campanha                    = c.cd_campanha
    LEFT OUTER JOIN Vendedor               v        ON v.cd_vendedor                    = cp.cd_vendedor 
    LEFT OUTER JOIN Operador_Telemarketing ot       ON p.cd_operador_telemarketing      = ot.cd_operador_telemarketing
    LEFT OUTER JOIN Cidade ci                       ON cp.cd_cidade                     = ci.cd_cidade
    LEFT OUTER JOIN Estado es                       ON cp.cd_estado                     = es.cd_estado
    Left Outer join Status_Prospeccao sp            on sp.cd_status_prospeccao          = p.cd_status_prospeccao
    LEFT OUTER JOIN acao_prospeccao acao            ON acao.cd_acao_prospeccao		    = p.cd_acao_prospeccao        
    LEFT OUTER JOIN Concorrente conc 	             on conc.cd_concorrente		          = p.cd_concorrente
  Where 
    ( case when cp.dt_cadastro_cliente is null then p.dt_prospeccao 
      else cp.dt_cadastro_cliente end ) between @Dt_inicio and @Dt_Fim  and 

    isnull(p.cd_operador_telemarketing,0) = case when isnull(@cd_operador_telemarketing,0) = 0 
                                                   then isnull(p.cd_operador_telemarketing,0) 
                                                   else isnull(@cd_operador_telemarketing,0) end 

    and

    isnull(p.cd_campanha,0)         = case when isnull(@cd_campanha,0) = 0 then isnull(p.cd_campanha,0) else @cd_campanha end and

    isnull(cp.cd_regiao_venda,0)      = case when isnull(@cd_regiao_venda,0) = 0 then isnull(cp.cd_regiao_venda,0) else isnull(@cd_regiao_venda,0) end and 

    isnull(cp.cd_tipo_cliente,0)      = case when isnull(@cd_tipo_cliente,0) = 0 then isnull(cp.cd_tipo_cliente,0) else isnull(@cd_tipo_cliente,0) end and 

    isnull(cp.cd_vendedor,0)          = case when isnull(@cd_vendedor,0) = 0 then isnull(cp.cd_vendedor,0) else isnull(@cd_vendedor,0) end and 

    isnull(cp.cd_fonte_informacao,0)  = case when isnull(@cd_fonte_informacao,0) = 0 then isnull(cp.cd_fonte_informacao,0) else isnull(@cd_fonte_informacao,0) end and

    isnull(cp.cd_ramo_atividade,0)    = case when isnull(@cd_ramo_atividade,0) = 0 then isnull(cp.cd_ramo_atividade,0) else isnull(@cd_ramo_atividade,0) end and 

    isnull(cp.cd_status_prospeccao,0) = case when isnull(@cd_status_prospeccao,0) = 0 then isnull(cp.cd_status_prospeccao,0) else isnull(@cd_status_prospeccao,0) end and
		
    isnull(p.dt_retorno_prospeccao,getdate()) between case when isnull(@dt_retorno_Inicio,'') = '' then isnull(p.dt_retorno_prospeccao,getdate()) else isnull(@dt_retorno_Inicio,'') end and
                                                        case when isnull(@dt_retorno_Fim,'') = '' then isnull(p.dt_retorno_prospeccao,getdate()) else isnull(@dt_retorno_Fim,'') end  and
    cp.nm_fantasia_cliente like @nm_fantasia_cliente + '%'

Group By
 	p.dt_retorno_prospeccao, 
 	p.dt_apresentacao, 
 	p.dt_visita, 
 	p.dt_fechamento, 
 	p.dt_retorno_prospeccao,
        p.dt_prospeccao,
	cp.cd_cliente_prospeccao, 
	cp.nm_fantasia_cliente,
	cp.cd_fone_cliente,
	cp.nm_email_cliente,
	cp.nm_site_cliente,
	v.nm_fantasia_vendedor,
	cm.nm_campanha,
	ot.nm_operador_telemarketing,
	ci.nm_cidade,
	cd_ddd_cliente, 
	es.nm_estado,
	p.dt_perda,
	p.dt_retorno_prospeccao,
        p.cd_prospeccao,
       sp.nm_status_prospeccao,
        p.nm_obs_prospeccao,
       acao.nm_acao_prospeccao,
       conc.nm_concorrente

order by 
  p.dt_retorno_prospeccao,
  p.dt_visita,
  p.dt_apresentacao,
  cp.nm_fantasia_cliente

--sp_help cliente_prospeccao_historico
--select * from cliente_prospeccao_campanha

