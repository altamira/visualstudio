
------------------------------------------------------------------------------------------------------
--pr_consulta_ocorrencia_relatorio
-------------------------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta das Ocorrências
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--                   11/05/2005
--                   13.05.2005 - Pesquisa por Cliente 
--                              - Consulta pelo Número da Ocorrência não filtra Data - Carlos Fernandes
--                   17.05.2005 - Colocado filtro pelo Código do Cliente - Carlos Fernandes
--                   16/11/2006 - Passa a filtrar por Origem da Ocorrência - ELIAS
-- 11.11.2010 - Ajustes Diversos - Carlos Fernandes
--------------------------------------------------------------------------------------------------------


CREATE PROCEDURE pr_consulta_ocorrencia_relatorio

--variáveis
  @dt_inicial           char(10),
  @dt_final             char(10),
  @dt_baixa_ocorrencia  char(10),
  @cd_status_ocorrencia int = 0 ,
  @cd_ocorrencia        int = 0,
  @cd_usuario_destino   int = 0,
  @cd_usuario_origem    int = 0,
  @cd_departamento      int = 0,
  @cd_tipo_documento    int = 0,
  @cd_documento         varchar(5) = '',
  @cd_item_documento    varchar(5) = '',
  @cd_cliente           int = 0,
  @cd_origem_ocorrencia int = 0

AS

  Declare @Select as varchar(4000)
  Declare @From   as varchar(4000)
  Declare @Where  as varchar(5000)

  Declare @SQL    as varchar(8000)

  Set @Select = ''
  Set @From   = ''
  Set @Where  = ''
  Set @SQL    = ''


  Set @Select =

  'Select '+
    'o.cd_ocorrencia, '+
    'o.dt_ocorrencia, '+
    'o.cd_tipo_pagamento_frete, '+
    'o.nm_obs_transporte, '+
    'o.dt_baixa_ocorrencia, '+
    'o.cd_usuario_destino, '+
    'ud.nm_usuario as nm_usuario_destino, ' +
    'o.cd_departamento, '+
    'dep.nm_departamento, '+
    'o.nm_obs_baixa, '+
    'o.cd_tipo_assunto, '+
    'o.cd_transportadora, '+
    'o.nm_assunto_ocorrencia, '+
    'o.cd_usuario_origem, '+
    'uo.nm_usuario as nm_usuario_origem, '+
    'o.cd_status_ocorrencia, '+
    'os.nm_tipo_status_ocorrencia, '+
    'os.sg_tipo_status_ocorrencia, '+
    'o.cd_usuario_gerente, '+
    'ug.nm_usuario as nm_usuario_gerente, '+
    'o.ic_frete_conta_ocorrencia, ' +
    'o.cd_tipo_doc_ocorrencia, '+
    'o.cd_documento, '+
    'o.cd_item_documento, '+
    'ot.nm_tipo_documento, '+
    'ot.sg_tipo_documento, '+
    'o.cd_tipo_custo, '+
    'oc.nm_custo_ocorrencia, '+
    'oc.sg_custo_ocorrencia, ' +
    'ta.nm_tipo_assunto, ' +
    'ta.sg_tipo_assunto, ' + 
    'pvi.cd_pedido_venda, ' + 
    'pvi.cd_item_pedido_venda, ' + 
    'pvi.qt_item_pedido_venda, '+
    'pvi.nm_produto_pedido, '+
    'cast(o.ds_ocorrencia as varchar(8000)) as ds_ocorrencia, '+
    'oo.nm_origem_ocorrencia, '+
    'case when o.cd_tipo_destinatario = 1 then ( select nm_fantasia_cliente from Cliente where o.cd_destinatario = cd_cliente ) end as Cliente'

  -----------------------------------------
  -- Cláusula From
  -----------------------------------------
  Set @From =
  ' From '+
    'Ocorrencia o Inner Join ' +
    '(Select * From EgisAdmin.dbo.Usuario) ud '+
      'on o.cd_usuario_destino = ud.cd_usuario Inner Join '+
    '(Select * From EgisAdmin.dbo.Usuario) uo '+
      'on o.cd_usuario_origem = uo.cd_usuario Left Outer Join '+
    '(Select * From EgisAdmin.dbo.Usuario) ug '+
      'on o.cd_usuario_gerente = ug.cd_usuario Inner Join '+
    'Departamento dep '+
      'on o.cd_departamento = dep.cd_departamento Inner Join '+
    'Ocorrencia_Tipo_Status os '+
      'on o.cd_status_ocorrencia = os.cd_tipo_status_ocorrencia Left Outer Join '+
    'Ocorrencia_Tipo_Documento ot '+
      'on o.cd_tipo_doc_ocorrencia = ot.cd_tipo_documento Left Outer Join '+
    'Ocorrencia_tipo_custo oc '+
      'on o.cd_tipo_custo = oc.cd_custo_ocorrencia Left Outer Join '+
    'Ocorrencia_Tipo_Assunto ta ' +
      ' on o.cd_tipo_assunto = ta.cd_tipo_assunto Left Outer Join '+
    'Origem_Ocorrencia oo' +
      ' on o.cd_origem_ocorrencia = oo.cd_origem_ocorrencia Left Outer Join '+
    'Pedido_Venda_Item pvi on o.cd_documento = pvi.cd_pedido_venda and o.cd_item_documento = pvi.cd_item_pedido_venda '

  -----------------------------------------
  -- Cláusula Where
  -----------------------------------------

  If ((@dt_inicial <> '') and (@dt_final <> '') and @cd_ocorrencia = 0)
    If @Where = ''
      Set @Where =   'Where '+
        'o.dt_ocorrencia Between '+ QuoteName(@dt_inicial,'''')+ ' and '+ QuoteName(@dt_final,'''')
    Else
      Set @Where = @Where + ' and o.dt_ocorrencia Between '+ QuoteName(@dt_inicial,'''')+ ' and '+ QuoteName(@dt_final,'''')

  If @dt_baixa_ocorrencia <> '  /  /  ' and @dt_baixa_ocorrencia <> '' and @dt_baixa_ocorrencia is not null
    If @Where = ''
      Set @Where =   'Where '+
        'o.dt_baixa_ocorrencia Between '+ QuoteName(@dt_baixa_ocorrencia,'''')+ ' and '+ QuoteName(@dt_baixa_ocorrencia,'''')
    Else
      Set @Where = @Where + ' and o.dt_baixa_ocorrencia Between '+ QuoteName(@dt_baixa_ocorrencia,'''')+ ' and '+ QuoteName(@dt_baixa_ocorrencia,'''')

  If @cd_status_ocorrencia <> 0
    If @Where = ''
      Set @Where = 'Where '+
        'o.cd_status_ocorrencia = ' + STR(@cd_status_ocorrencia)
    Else
      Set @Where = @Where + 'and o.cd_status_ocorrencia = ' + STR(@cd_status_ocorrencia)


  If @cd_ocorrencia <> 0
    If @Where = ''
      Set @Where = 'Where '+
        'o.cd_ocorrencia = ' + STR(@cd_ocorrencia)
    Else
      Set @Where = @Where + 'and o.cd_ocorrencia = ' + STR(@cd_ocorrencia)

  If @cd_usuario_destino <> 0
    If @Where = ''
      Set @Where = 'Where '+
        'o.cd_usuario_destino = ' + STR(@cd_usuario_destino)
    Else
      Set @Where = @Where + 'and o.cd_usuario_destino = ' + STR(@cd_usuario_destino)

  If @cd_usuario_origem <> 0
    If @Where = ''
      Set @Where = 'Where '+
        'o.cd_usuario_origem = ' + STR(@cd_usuario_origem)
    Else
      Set @Where = @Where + 'and o.cd_usuario_origem = ' + STR(@cd_usuario_origem)

  If @cd_departamento <> 0
    If @Where = ''
      Set @Where = 'Where '+
        'o.cd_departamento = ' + STR(@cd_departamento)
    Else
      Set @Where = @Where + 'and o.cd_departamento = ' + STR(@cd_departamento)


  If @cd_tipo_documento <> 0
    If @Where = ''
      Set @Where = 'Where '+
        'o.cd_tipo_doc_ocorrencia = ' + STR(@cd_tipo_documento)
    Else
      Set @Where = @Where + 'and o.cd_tipo_doc_ocorrencia = ' + STR(@cd_tipo_documento)

  If @cd_documento <> 0
    If @Where = ''
      Set @Where = 'Where '+
        'o.cd_documento = ' + @cd_documento
    Else
      Set @Where = @Where + 'and o.cd_documento = ' + @cd_documento

  If @cd_item_documento <> 0
    If @Where = ''
      Set @Where = 'Where '+
        'o.cd_item_documento = ' + @cd_item_documento
    Else
      Set @Where = @Where + 'and o.cd_item_documento = ' + @cd_item_documento

  --Cliente
  --Carlos 17.05.2005

  If @cd_cliente <> 0
    If @Where = ''
      Set @Where = 'Where '+
        'o.cd_tipo_destinatario = 1 and o.cd_destinatario = ' + str(@cd_cliente)
    Else
      Set @Where = @Where + 'and o.cd_tipo_destinatario = 1 and o.cd_destinatario = ' + str(@cd_cliente)

  If @cd_origem_ocorrencia <> 0
    If @Where = ''
      Set @Where = 'Where '+
        'o.cd_origem_ocorrencia = ' + str(@cd_origem_ocorrencia)
    Else
      Set @Where = @Where + 'and o.cd_origem_ocorrencia = ' + str(@cd_origem_ocorrencia)


  Set @Where = @Where + ' Order By o.cd_ocorrencia'

  Set @Sql = IsNull(@Select,' ') + IsNull(@From,' ') + Isnull(@Where,' ')

   print @sql
  Exec(@SQL)

