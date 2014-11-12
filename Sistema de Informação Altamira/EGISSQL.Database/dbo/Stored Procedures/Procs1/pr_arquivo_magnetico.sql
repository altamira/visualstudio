

create procedure pr_arquivo_magnetico
@ic_parametro              int,
@cd_arquivo_magnetico      int,
@cd_tipo_sessao            int,
@cd_sessao_documento       int,
@cd_sessao_arquivo_magneti int = 0

as

-------------------------------------------------------------------------------
if @ic_parametro = 1   -- Campos de um Arquivo Magnético (Remessa)
-------------------------------------------------------------------------------

  begin

  /* OBS:
       Os tipos de sessão são os seguintes
       1 - HEADER
       2 - DETALHE
       3 - TRAILER (rodapé)
  */
      
    select
      c.*,
      t.ic_data_sistema,
      t.ic_data_inicial,
      t.ic_data_final,
      t.ic_contador_documento,
      t.ic_somatoria,
      t.ic_contador_detalhe,
      t.ic_repetir_caracter,
      t.ic_limpa_literal,
      t.ic_preenche_zero,
      t.ic_alinhamento,
      t.ic_mostra_virgula,
      t.ic_tipo_campo,
      t.nm_formato_mascara,
      t.ic_contador_sessao,
      t.ic_sequencia_grupo,
      t.ic_contador_regs_lote,
      t.ic_sequencia_arquivo_mag,
      t.ic_sequencia_sessao
    from
      campo_arquivo_magnetico c,
      tipo_campo_arquivo_magnetico t
    where 
      c.cd_tipo_campo       = t.cd_tipo_campo and
      c.cd_sessao_documento = @cd_sessao_documento
    order by
      c.cd_sessao_documento,
      IsNull( c.ic_groupby, 'N' ) desc,
      isnull(c.cd_inicio_posicao,0)
    
  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2     -- Parâmetros p/ execução do Arquivo Magnetico
-------------------------------------------------------------------------------
  begin

    select * from
      parametro_arquivo_magnetico with (nolock) 
    where
      cd_documento_magnetico = @cd_arquivo_magnetico and
      cd_sessao_documento    = @cd_sessao_documento

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 3    -- retorna o tamanho do registro
-------------------------------------------------------------------------------
  begin

    select
      max(cd_fim_posicao) as 'qt_tamanho_registro'
    from
      campo_arquivo_magnetico with (nolock) 
    where 
      cd_sessao_documento in (select 
                                cd_sessao_arquivo_magneti 
                              from 
                                sessao_arquivo_magnetico with (nolock) 
                              where 
                                cd_documento_magnetico = @cd_arquivo_magnetico and
                                cd_tipo_sessao = @cd_tipo_sessao)      
  end
-------------------------------------------------------------------------------
else if @ic_parametro = 4              -- lista as sessões do arquivo magnetico
-------------------------------------------------------------------------------
  begin

--select * from sessao_arquivo_magnetico

    select 	
		S.cd_documento_magnetico,
		S.cd_tipo_sessao,
		S.cd_sessao_arquivo_magneti,  
		S.nm_sessao,                  
		S.sg_sessao,                  
		S.ds_sessao,                  
		S.cd_usuario,                 
		S.dt_usuario,                 
		S.ic_sessao_inativa,          
		IsNull(S.ic_atualiza_fim,'S') as ic_atualiza_fim,
		Cast( 0 as integer )          as CONTADOR_SESSAO ,
                isnull(s.ic_detalhes,'N')     as Detalhe,
                isnull(s.ic_filtro,'S')       as Filtro
	from
      sessao_arquivo_magnetico s,
      tipo_sessao_arquivo_magnetico ts
    where     
      s.cd_documento_magnetico = @cd_arquivo_magnetico  and
      isnull(s.ic_sessao_inativa,'N') <> 'S'  and
      ts.cd_tipo_sessao = s.cd_tipo_sessao
    order by
      ts.cd_tipo_sessao,
      isnull(s.cd_ordem_sessao,1)

--select * from sessao_arquivo_magnetico

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 5         -- lista os documentos de envio
-------------------------------------------------------------------------------
  begin

    --select * from documento_arquivo_magnetico

    select
      d.*,
      m.nm_modulo,
      dbo.fn_proxima_sequencia_documento_magnetico( d.cd_documento_magnetico ) as 'sequencia_arquivo_magnetico',
      isnull(p.qt_posicao_documento,0)                                         as qt_posicao_documento,
      isnull(p.qt_posicao_instrucao,0)                                         as qt_posicao_instrucao,
      isnull(qt_posicao_documento_instrucao,0)                                 as qt_posicao_documento_instrucao,
      isnull(qt_posicao_sequencial,0)                                          as qt_posicao_sequencial,
      isnull(qt_posicao_bancario,0)                                            as qt_posicao_bancario,
      isnull(qt_posicao_valor_documento,0)                                     as qt_posicao_valor_documento,
      isnull(qt_posicao_juros,0)                                               as qt_posicao_juros

    from
      documento_arquivo_magnetico d                         with (nolock) 
      left outer join egisadmin.dbo.modulo m                with (nolock) on m.cd_modulo = d.cd_modulo
      left outer join documento_arquivo_magnetico_posicao p with (nolock) on p.cd_documento_magnetico = d.cd_documento_magnetico

    where
      d.ic_envio_recebimento = 'E' and
      isnull(d.ic_ativo_documento,'S') = 'S'
    order by
      d.nm_documento_magnetico    

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 6         -- lista as configurações para atualização (Remessa)
-------------------------------------------------------------------------------
  begin

    select 
      a.cd_documento_magnetico,
      a.cd_parametro_atualizacao,
      a.nm_procedimento,
      a.nm_parametro_procedimento,
      a.cd_sessao_arquivo_magneti,
      a.cd_campo_magnetico,
      a.ic_tipo_parametro,
      c.nm_campo
    from
      atualizacao_arquivo_magnetico a,
      campo_arquivo_magnetico c
    where
      a.cd_sessao_arquivo_magneti = c.cd_sessao_documento and
      a.cd_campo_magnetico = c.cd_campo_magnetico and
      cd_documento_magnetico = @cd_arquivo_magnetico and
      cd_sessao_documento = @cd_sessao_documento
    order by
      cd_sessao_arquivo_magneti,
      nm_procedimento

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 7         -- lista os documentos de retorno
-------------------------------------------------------------------------------
  begin
    select
      d.*,
      (select top 1 b.cd_numero_banco from banco b 
       where b.cd_arquivo_magnetico_retorno = d.cd_documento_magnetico) as cd_numero_banco
    from
      documento_arquivo_magnetico d
    where
      d.ic_envio_recebimento = 'R' and
      isnull(d.ic_ativo_documento,'S') = 'S'
    order by
      d.nm_documento_magnetico    

  end
  
-------------------------------------------------------------------------------
if @ic_parametro = 8   -- Campos de um Arquivo Magnético (Retorno)
-------------------------------------------------------------------------------
  begin

  /* OBS:
       Os tipos de sessão são os seguintes
       1 - HEADER
       2 - DETALHE
       3 - TRAILER (rodapé)
  */
      
    select
      c.*,
      t.ic_data_sistema,
      t.ic_data_inicial,
      t.ic_data_final,
      t.ic_contador_documento,
      t.ic_somatoria,
      t.ic_contador_detalhe,
      t.ic_repetir_caracter,
      t.ic_limpa_literal,
      t.ic_preenche_zero,
      t.ic_alinhamento,
      t.ic_mostra_virgula,
      t.ic_tipo_campo,
      t.nm_formato_mascara
    from
      campo_arquivo_magnetico c,
      tipo_campo_arquivo_magnetico t
    where 
      c.cd_tipo_campo = t.cd_tipo_campo and
      c.cd_sessao_documento in (select 
                                  cd_sessao_arquivo_magneti 
                                from 
                                  sessao_arquivo_magnetico 
                                where 
                                  cd_documento_magnetico = @cd_arquivo_magnetico and
                                  cd_tipo_sessao = @cd_tipo_sessao and
                                  isnull(ic_sessao_inativa,'N') <> 'S')
    order by
      c.cd_sessao_documento,
      c.cd_inicio_posicao
    
  end

-------------------------------------------------------------------------------
else if @ic_parametro = 9         -- lista as configurações para atualização (Retorno)
-------------------------------------------------------------------------------
  begin

    select 
      a.cd_documento_magnetico,
      a.cd_parametro_atualizacao,
      a.nm_procedimento,
      a.nm_parametro_procedimento,
      a.cd_sessao_arquivo_magneti, 
      a.cd_campo_magnetico,
      a.ic_tipo_parametro,
      c.nm_campo
    from
      atualizacao_arquivo_magnetico a with (nolock) 
    left outer join
      campo_arquivo_magnetico c
    on
      c.cd_campo_magnetico  = a.cd_campo_magnetico and
      c.cd_sessao_documento = a.cd_sessao_arquivo_magneti
    where
      a.cd_documento_magnetico = @cd_arquivo_magnetico and
      a.cd_sessao_arquivo_magneti in (select 
                                        cd_sessao_arquivo_magneti
                                      from 
                                        sessao_arquivo_magnetico
                                      where 
                                        cd_tipo_sessao = 2 and -- Detalhe
                                        cd_documento_magnetico = @cd_arquivo_magnetico)
    order by
      a.cd_sessao_arquivo_magneti,
      a.nm_procedimento

  end
-------------------------------------------------------------------------------
else if @ic_parametro = 10              -- lista as sessões de detalhes (Filhas)
-------------------------------------------------------------------------------
  begin
    select 	
      distinct cd_sessao_arquivo_magnetiFilho  
    from
      sessao_arquivo_magnetico s,
		sessao_arquivo_detalhe sad
    where     
      isnull(s.ic_sessao_inativa,'N') <> 'S'  and
      isnull(s.ic_detalhes,'N') = 'S'  and
		sad.cd_sessao_arquivo_magnetiPai =@cd_sessao_arquivo_magneti 

  end
else
  return


