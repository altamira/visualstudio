create procedure pr_controle_emissao_documento
-----------------------------------------------------------
--pr_controle_emissao_documento
------------------------------------------------------------
-- GBS - Global Bussiness Solution Ltda                 2004
------------------------------------------------------------
-- Stored Procedure     : Microsoft SQL Server 2000
-- Autor(es)            : Igor Gama
-- Banco de Dados       : EGISSQL
-- Objetivo             : Trazer todos os documentos vinculados aos pedidos de importacao ou exportação
-- Data                 : 24.03.2004
-- Parametros           : cd_pedido e cd_modulo
-- Atualização          : 28/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 02.07.2007 - Verificação - Carlos Fernandes
-------------------------------------------------------------------------------------------
@cd_modulo    int,
@cd_documento int
as
  If IsNull(@cd_documento, 0) = 0
    Set @cd_documento = 0

  Declare @ic_tipo char(1)
  Declare @cd_tipo_documento int

  If @cd_modulo = 57 
  Begin
    Set @ic_tipo = 'I'
    Set @cd_tipo_documento = 10
  End Else If @cd_modulo = 58
  Begin
    Set @ic_tipo = 'E'
    Set @cd_tipo_documento = 11
  End

	select    
    max(dt_emissao_documento)  as 'dt_emissao_documento',
    max(cd_documento)          as 'cd_documento',
    cd_tipo_documento          as 'cd_tipo_documento',
    cd_tipo_documento_comex    as 'cd_tipo_documento_comex',
    Cast(null as float)        as 'qt_vias_documento',
    cast(null as varchar(255)) as 'ds_observacao_documento',
    Cast(null as int)          as 'cd_usuario'
	Into
    #Documentos
  From 
	  controle_emissao_documento
  where
    cd_tipo_documento = @cd_tipo_documento and 
    (cd_documento = @cd_documento or @cd_documento = 0)
  Group By cd_tipo_documento, cd_tipo_documento_comex 

  Update #Documentos
    set qt_vias_documento       = c.qt_vias_documento,
        ds_observacao_documento = c.ds_observacao_documento,
        cd_usuario              = c.cd_usuario
  From Controle_Emissao_Documento c, #Documentos d
  Where c.cd_documento = d.cd_documento and
        c.cd_tipo_documento = d.cd_tipo_documento

	select
    0  as 'selecionado',
    (select isnull(max(cd_controle_emissao_doc),0) From controle_emissao_documento) as 'cd_controle_emissao_doc',
    d.dt_emissao_documento,
    d.cd_documento,
    @cd_tipo_documento as 'cd_tipo_documento',
    td.cd_tipo_documento_comex,
    d.qt_vias_documento,
    d.ds_observacao_documento,
    u.nm_fantasia_usuario,
		td.nm_tipo_documento_comex,    
		td.cd_classe_relatorio,
    c.nm_classe,
    td.cd_idioma,
		td.cd_usuario,
		td.dt_usuario
	From
	  Tipo_Documento_Comex td
      Left Outer Join
    EgisAdmin.dbo.Classe c
      on td.cd_classe_relatorio = c.cd_classe
      Left Outer Join
    #Documentos d
      on td.cd_tipo_documento_comex = d.cd_tipo_documento_comex
      LEft Outer Join
    EgisAdmin.dbo.Usuario u
      on d.cd_usuario = u.cd_usuario
	where
	  ic_tipo_documento_comex in (@ic_tipo, 'A') and
    isnull(ic_ativo_documento,'S') = 'S'

