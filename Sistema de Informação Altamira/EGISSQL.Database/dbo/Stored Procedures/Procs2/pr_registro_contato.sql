
-----------------------------------------------------------------------------------------
--pr_registro_contato
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                                               2004
-----------------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Daniel C.Neto.
--                      : 
--Banco de Dados        : EGISSQL
--Objetivo              : Consulta de Registro de Contato
--Data                  : 05/09/2006
-- 11/09/2006 - Incluído funcionalidade de agencia_banco - Daniel c. Neto.
-- 25.02.2008 - Verificação e Ajustes na Procedure - Carlos Fernandes
--------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE pr_registro_contato
@dt_inicio                 datetime = '',
@dt_fim                    datetime = '',
@cd_operador_telemarketing int = 0,
@qtd_registros             int = 0,
@cd_usuario                int = 0

as

--select * from egisadmin.dbo.usuario
--select * from operador_telemarketing

--select @dt_inicio
--select @dt_fim

declare @top int

if IsNull(@qtd_registros,0) = 0 
   set ROWCOUNT 10000
else
   set ROWCOUNT @qtd_registros


SELECT 
   cp.*,
   'S' as 'ic_edicao', 
	case when cp.cd_cliente    is not null then 'S' else 'N' end                      as 'ic_cliente',
	case when cp.cd_fornecedor is not null then 'S' else 'N' end                      as 'ic_fornecedor',
	case when cast(convert(varchar,cp.dt_real_retorno,101) as datetime) > 
                  cast(convert(varchar,cp.dt_previsto_retorno,101) as datetime) 
        then 'S' else 'N' end                                                             as 'ic_retorno_atraso',
	case when cp.cd_banco is not null then 'S' else 'N' end                           as 'ic_banco',
	case when (isnull(cp.dt_real_retorno ,'') = '') then 'N' else 'S' end             as 'ic_retorno',
        --contato
  	(select top 1 nm_tipo_contato 
         from Tipo_contato x
         where x.cd_tipo_contato = cp.cd_tipo_contato)  as nm_tipo_contato ,
	ot.nm_operador_telemarketing,		
  	IsNull(cli.cd_ddd, forn.cd_ddd) as cd_ddd, 
  	IsNull(ab.cd_telefone_agencia_banco, IsNull(cli.cd_telefone, forn.cd_telefone))         as cd_telefone, 
        acc.nm_acao_contato,
        IsNull(comp.nm_fantasia_comprador,v.nm_fantasia_vendedor) as nm_vend_comp,
        IsNull(ab.nm_agencia_banco,IsNull(cli.nm_fantasia_cliente,forn.nm_fantasia_fornecedor)) as nm_fantasia_destinatario,
        IsNull(ab.nm_agencia_banco,IsNull(cli.nm_razao_social_cliente,forn.nm_razao_social))    as nm_razao_social,
        IsNull(ba.nm_banco_assunto,IsNull(ca.nm_cliente_assunto,fa.nm_fornecedor_assunto))      as nm_assunto
    
        
into
  #Registro_Contato      


FROM
    Registro_Contato cp                             with (nolock) 
               
    LEFT OUTER JOIN Campanha_Cliente       c        with (nolock) ON c.cd_cliente                      = cp.cd_cliente
    LEFT OUTER JOIN Campanha              cm        with (nolock) ON cm.cd_campanha                    = c.cd_campanha
    LEFT OUTER JOIN Operador_Telemarketing ot       with (nolock) ON cp.cd_operador_telemarketing      = ot.cd_operador_telemarketing
    left outer join Acao_Contato acc                with (nolock) on acc.cd_acao_contato = cp.cd_acao_contato
    left outer join Vendedor v                      with (nolock) on v.cd_vendedor = cp.cd_vendedor
    left outer join Comprador comp                  with (nolock) on comp.cd_comprador = cp.cd_comprador
    left outer join Cliente cli                     with (nolock) on cli.cd_cliente = cp.cd_cliente
    left outer join Fornecedor forn                 with (nolock) on forn.cd_fornecedor = cp.cd_fornecedor
    left outer join Banco b                         with (nolock) on b.cd_banco = cp.cd_banco
    left outer join Agencia_Banco ab                with (nolock) on ab.cd_agencia_banco = cp.cd_agencia_banco

    left outer join Cliente_Assunto ca on ca.cd_cliente_assunto = cp.cd_assunto_contato and
                                          cp.cd_tipo_contato = 1 
    left outer join Fornecedor_Assunto fa on fa.cd_Fornecedor_assunto = cp.cd_assunto_contato and
                                          cp.cd_tipo_contato = 2 
    left outer join Banco_Assunto ba on ba.cd_banco_assunto = cp.cd_assunto_contato and
                                          cp.cd_tipo_contato = 3 


  Where 
    ( cp.dt_registro_contato between @dt_inicio and @dt_fim ) and
    isnull(cp.cd_operador_telemarketing,0) = case when isnull(@cd_operador_telemarketing,0) = 0 
                                                   then isnull(cp.cd_operador_telemarketing,0) 
                                                   else isnull(@cd_operador_telemarketing,0) end

order by 
  cp.dt_registro_contato


--Verifica os registros digitados diretamente na tabela de cliente_historico
--select * from cliente_historico

select
  h.cd_sequencia_historico   as cd_registro_contato,      
  h.dt_historico_lancamento  as dt_registro_contato,
  null                       as cd_operador_telemarketing,
  1                          as cd_tipo_contato,
  h.cd_cliente,
  null                     as cd_fornecedor,
  null                     as cd_banco,
  null                     as cd_agencia_banco,
  null                     as cd_cliente_prospeccao,
  h.cd_contato               as cd_contato_cliente,
  null                     as cd_contato_fornecedor,
  null                     as cd_contato_agencia,
  0                        as qt_dia_retorno,
  h.dt_historico_retorno     as dt_previsto_retorno,
  h.dt_real_retorno,
  null                     as cd_assunto_contato,
  null                     as cd_acao_contato,
  cast(h.nm_assunto        as varchar(40))       as nm_obs_registro, 
  --h.ds_historico_lancamento  as ds_registro_contato,
  cast('' as varchar(8000))as ds_registro_contato,
  h.cd_vendedor,
  null                     as cd_comprador,
  h.cd_usuario,
  h.dt_usuario,
  'N' as 'ic_edicao', 
  'S' as 'ic_cliente',
  'N' as 'ic_fornecedor',
  case when cast(convert(varchar,h.dt_real_retorno,101) as datetime) > 
                  cast(convert(varchar,h.dt_historico_retorno,101) as datetime) 
  then 'S' else 'N' end                                                               as 'ic_retorno_atraso',
  'N'                                                                                 as 'ic_banco',

  case when (isnull(h.dt_real_retorno ,'') = '') then 'N' else 'S' end                as 'ic_retorno',

  --contato

  cast(	(select top 1 nm_tipo_contato 
         from Tipo_contato x
         where x.cd_tipo_contato = 1) as varchar) as nm_tipo_contato ,

	cast(null as varchar)                     as nm_operador_telemarketing,		
  	IsNull(cli.cd_ddd, '')                    as cd_ddd, 
  	IsNull(cli.cd_telefone, '')               as cd_telefone, 
        cast(null as varchar) as nm_acao_contato,
        IsNull(v.nm_fantasia_vendedor,'')         as nm_vend_comp,
        IsNull(cli.nm_fantasia_cliente,'')        as nm_fantasia_destinatario,
        IsNull(cli.nm_razao_social_cliente,'')    as nm_razao_social,
        IsNull(ca.nm_cliente_assunto,'')          as nm_assunto
  
into
  #Cliente_historico
from
  cliente_historico h                with (nolock) 
  left outer join Vendedor v         with (nolock) on v.cd_vendedor         = h.cd_vendedor
  left outer join Cliente cli        with (nolock) on cli.cd_cliente        = h.cd_cliente
  left outer join Cliente_Assunto ca with (nolock) on ca.cd_cliente_assunto = h.cd_cliente_assunto 


where
  ( h.dt_historico_lancamento between @dt_inicio and @dt_fim ) and
  ( isnull(h.cd_registro_contato,0)=0 )   


--select * from #Cliente_historico
--select * from #Registro_contato

--Insere os Registros

-- insert into #Registro_Contato
--  select
--    *
--  from
--    #Cliente_Historico


select
  *
from
  #Registro_Contato
order by
  dt_registro_contato


