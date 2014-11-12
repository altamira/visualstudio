
CREATE PROCEDURE pr_sindicato
@nm_fantasia varchar(50)

AS

  Select 
    sc.cd_sindicato,
    sc.nm_sindicato,
    sc.nm_complemento_sindicato,
    sc.nm_fantasia_sindicato,
    sc.nm_endereco_sindicato,
    sc.nm_bairro_sindicato,
    sc.cd_ddd_sindicato,
    sc.cd_fone_sindicato,
    sc.cd_fax_sindicato,
    sc.nm_contato_sindicato,
    sc.nm_email_sindicato,
    sc.nm_site_sindicato,
    sc.cd_classe_sindicato,
    sc.cd_identifica_cep,
    sc.cd_pais,
    sc.cd_estado,
    sc.cd_cidade,
    sc.cd_usuario,
    sc.dt_usuario,
    sc.dt_dissidio_sindicato,
    sc.cd_cep,
    p.nm_pais,
    ci.nm_cidade,
    es.sg_estado,
    sc.nm_periodo_sindicato,
    sc.ic_contribuicao_funcionario,
    sc.qt_mes_contribuicao,
    m.nm_mes,
    sc.pc_assistencial_sindicato,
    sc.pc_confederativa_sindicato

  from sindicato sc  with (nolock) 
       left outer join pais p    on (sc.cd_pais = p.cd_pais)
       left outer join cidade ci on (sc.cd_cidade = ci.cd_cidade)
       left outer join Estado es on (sc.cd_estado = es.cd_estado)
       left outer join Mes m     on (sc.qt_mes_contribuicao = m.cd_mes )
  where 
       (sc.nm_fantasia_sindicato like @nm_fantasia + '%') 

  order by sc.nm_sindicato

