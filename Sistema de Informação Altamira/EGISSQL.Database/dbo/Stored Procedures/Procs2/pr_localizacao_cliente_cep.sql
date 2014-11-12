
-------------------------------------------------------------------------------
--sp_helptext pr_localizacao_cliente_cep
-------------------------------------------------------------------------------
--pr_localizacao_cliente_cep
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Cliente por CEP
--Data             : 28.06.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_localizacao_cliente_cep
@cd_cep varchar(8) = ''
as


if @cd_cep <> ''  
begin

  select
    c.cd_cep,
    c.cd_cliente,
    c.nm_fantasia_cliente,
    c.nm_razao_social_cliente,
    c.nm_endereco_cliente,
    c.cd_numero_endereco,
    c.nm_bairro,
    rtrim(ltrim(isnull(c.nm_endereco_cliente,'S/E'))) + ', ' + 
    rtrim(ltrim(isnull(cast(c.cd_numero_endereco as varchar(10)),'S/N')))  + ', ' +  
    isnull(rtrim(ltrim(c.nm_bairro)),'S/B') as EndRel,
    c.nm_complemento_endereco,
    ci.nm_cidade,
    uf.sg_estado,
    pa.nm_pais,
    c.dt_cadastro_cliente,
    ve.nm_vendedor,
    tm.nm_tipo_mercado,
    ra.nm_ramo_atividade,
    cv.nm_criterio_visita,
    r.nm_regiao,
    cg.nm_cliente_grupo,
    fi.nm_fonte_informacao,
    cc.nm_contato_cliente
  from 
    cliente                          c  with (nolock) 
    left outer join cidade           ci with (nolock) on ci.cd_cidade           = c.cd_cidade 
    left outer join estado           uf with (nolock) on uf.cd_estado           = c.cd_estado
    left outer join pais             pa with (nolock) on pa.cd_pais             = c.cd_pais
    left outer join vendedor         ve with (nolock) on ve.cd_vendedor         = c.cd_vendedor
    left outer join tipo_mercado     tm with (nolock) on tm.cd_tipo_mercado     = c.cd_tipo_mercado
    left outer join ramo_atividade   ra with (nolock) on ra.cd_ramo_atividade   = c.cd_ramo_atividade
    left outer join criterio_visita  cv with (nolock) on cv.cd_criterio_visita  = c.cd_criterio_visita
    left outer join regiao           r  with (nolock) on r.cd_regiao            = c.cd_regiao 
    left outer join cliente_grupo    cg with (nolock) on cg.cd_cliente_grupo    = c.cd_cliente_grupo
    left outer join fonte_informacao fi with (nolock) on fi.cd_fonte_informacao = c.cd_fonte_informacao
    left outer join cliente_contato  cc with (nolock) on cc.cd_cliente          = c.cd_cliente and
                                                         cc.cd_contato          = (select
                                                                                     min(ccc.cd_contato)
                                                                                   from
                                                                                     cliente_contato ccc -- Retorna o Primeiro Contato do Cliente 
                                                                                   where
                                                                                     ccc.cd_cliente = c.cd_cliente)
  where
    c.cd_cep like @cd_cep+'%'
  order by
    c.cd_cep,c.nm_fantasia_cliente
  
end


