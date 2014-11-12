

CREATE PROCEDURE pr_lancamento_padrao
@cd_empresa           int,
@nm_lancamento_padrao varchar(20)

AS

--select * from lote_contabil_padrao
--select * from lancamento_padrao


  select
   	l.cd_lancamento_padrao, 
  	l.nm_lancamento_padrao, 
  	l.cd_conta_debito_padrao, 
   	l.cd_conta_credito_padrao, 
  	l.cd_mas_deb_lancto_padrao, 
   	l.cd_mas_cred_lancto_padrao, 
  	l.cd_historico_contabil, 
  	l.ic_compl_historico_padrao, 
   	l.cd_usuario, 
  	l.dt_usuario, 
  	l.cd_tipo_contabilizacao, 
  	l.nm_obs_lancamento_padrao, 
   	l.ic_ctbs_lancamento_padrao, 
  	l.ic_tipo_operacao, 
  	l.cd_tipo_mercado, 
  	l.cd_conta_plano, 
  	l.cd_empresa, 
  	l.cd_departamento, 
   	l.cd_modulo, 
  	l.cd_lote_contabil_padrao, 
  	cast(l.ds_historico_lancto_pad as varchar(2000)) as ds_historico_lancto_pad, 
  	l.cd_conta_debito, 
   	l.cd_conta_credito,
    
    h.nm_historico_contabil,
    --t.cd_lote_contabil_padrao,

    p.nm_conta,
    p.cd_mascara_conta,
    p.cd_conta_reduzido,

    pd.nm_conta          as 'nm_conta_debito',
    pd.cd_mascara_conta  as 'cd_mascara_conta_deb',
    pd.cd_conta_reduzido as 'cd_conta_reduzido_deb',

    pc.nm_conta          as 'nm_conta_credito',
    pc.cd_mascara_conta  as 'cd_mascara_conta_cred',
    pc.cd_conta_reduzido as 'cd_conta_reduzido_cred',

    d.nm_departamento,
    m.nm_modulo,    
    tc.nm_tipo_contabilizacao,
    tm.nm_tipo_mercado

  from
    Lancamento_Padrao l with (nolock)

  left outer join  Historico_Contabil h  on  h.cd_historico_contabil = l.cd_historico_contabil

--  left outer join Lote_Contabil_Padrao t on t.cd_empresa = l.cd_empresa and
--                                            t.cd_lote_contabil_padrao = l.cd_lote_contabil_padrao

  left outer join Plano_conta p          on  p.cd_empresa             = l.cd_empresa and 
                                             p.cd_conta               = l.cd_conta_plano

  left outer join Plano_conta pd         on  pd.cd_empresa            = l.cd_empresa and 
                                             pd.cd_conta              = l.cd_conta_debito

  left outer join Plano_conta pc         on  pc.cd_empresa            = l.cd_empresa and 
                                             pc.cd_conta              = l.cd_conta_credito

  left outer join Departamento d         on d.cd_departamento         = l.cd_departamento
  left outer join Egisadmin.dbo.Modulo m on m.cd_modulo               = l.cd_modulo
  left outer join Tipo_Contabilizacao tc on tc.cd_tipo_contabilizacao = l.cd_tipo_contabilizacao
  left outer join Tipo_Mercado tm        on tm.cd_tipo_mercado        = l.cd_tipo_mercado

  where
    l.cd_empresa = @cd_empresa and
    ((l.nm_lancamento_padrao like '%'+@nm_lancamento_padrao+'%') or (@nm_lancamento_padrao = ''))
  order by
    cd_lancamento_padrao
   
