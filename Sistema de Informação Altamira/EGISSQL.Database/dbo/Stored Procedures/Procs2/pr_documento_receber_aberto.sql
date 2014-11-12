
CREATE PROCEDURE pr_documento_receber_aberto
@dt_inicial             datetime,
@dt_final               datetime,
@ic_ordem               char(1),
@cd_cliente             int,
@cd_vendedor            int,
@cd_portador            int,
@cd_tipo_documento      int,
@cd_tipo_cobranca       int,
@cd_cliente_grupo       int = 0,
@cd_doc_receber         varchar(10) = '',
@cd_centro_custo        int = 0

AS
  declare @InstrucaoSQL varchar(5000)

  set @InstrucaoSQL = ' SELECT '+
                        ' D.CD_IDENTIFICACAO as Documento,'+
                        ' D.CD_CLIENTE as Codigo, '+
                        ' C.NM_FANTASIA_CLIENTE as Cliente, '+
                        ' D.DT_EMISSAO_DOCUMENTO as Emissao, '+
                        ' D.DT_VENCIMENTO_DOCUMENTO as Vencimento, '+
                        ' cast(0 as numeric(25,2)) as Oscilacao, '+
                        ' cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) as Saldo, '+
                        ' D.CD_TIPO_COBRANCA as Cod, '+
                        ' D.CD_VENDEDOR as Ven, '+
                        ' D.CD_PORTADOR as Por, '+
                        ' NULL as CC, '+
                        ' cast((D.DT_VENCIMENTO_DOCUMENTO - GETDATE()) as int) as Dias, '+
                        ' CG.NM_CLIENTE_GRUPO, ' +
                        ' CC.NM_CENTRO_CUSTO ' +
                      ' FROM '+
                        ' DOCUMENTO_RECEBER D WITH (NOLOCK) '+
                        ' LEFT OUTER JOIN CLIENTE C ON C.CD_CLIENTE = D.CD_CLIENTE '+
                        ' LEFT OUTER JOIN CLIENTE_GRUPO CG ON CG.CD_CLIENTE_GRUPO = C.CD_CLIENTE_GRUPO '+
                        ' LEFT OUTER JOIN CENTRO_CUSTO  CC ON CC.CD_CENTRO_CUSTO = D.CD_CENTRO_CUSTO '+
                      ' WHERE '+
                        ' cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) > 0 AND '+
                        ' D.DT_VENCIMENTO_DOCUMENTO BETWEEN '+
                        +''''+cast( @dt_inicial as varchar )+''''+' AND '+
                        +''''+cast( @dt_final as varchar )+''''+' AND '+
                        ' D.CD_CLIENTE = C.CD_CLIENTE AND '+
                        ' d.dt_cancelamento_documento         is null                           and '+
                        ' d.dt_devolucao_documento            is null                           '

  if isnull(@cd_cliente, 0) <> 0 
    set @InstrucaoSQL = @InstrucaoSQL + ' AND D.CD_CLIENTE = '+''''+cast(@cd_cliente as varchar(6))+''''

  if isnull(@cd_vendedor, 0) <> 0
    set @InstrucaoSQL = @InstrucaoSQL + ' AND D.CD_VENDEDOR = '+''''+cast(@cd_vendedor as varchar(6))+''''

  if isnull(@cd_portador, 0) <> 0 
    set @InstrucaoSQL = @InstrucaoSQL + ' AND D.CD_PORTADOR = '+''''+cast(@cd_portador as varchar(6))+''''

  if isnull(@cd_tipo_documento, 0) <> 0
    set @InstrucaoSQL = @InstrucaoSQL + ' AND D.CD_TIPO_DOCUMENTO = '+''''+cast(@cd_tipo_documento as varchar(6))+''''   

  if isnull(@cd_tipo_cobranca, 0) <> 0
    set @InstrucaoSQL = @InstrucaoSQL + ' AND D.CD_TIPO_COBRANCA = '+''''+cast(@cd_tipo_cobranca as varchar(6))+''''   

  if isnull(@cd_cliente_grupo, 0) <> 0
    set @InstrucaoSQL = @InstrucaoSQL + ' AND C.CD_CLIENTE_GRUPO = '+''''+cast(@cd_cliente_grupo as varchar(6))+''''

  if isnull(@cd_centro_custo, 0) <> 0
    set @InstrucaoSQL = @InstrucaoSQL + ' AND D.CD_CENTRO_CUSTO = '+''''+cast(@cd_centro_custo as varchar(6))+''''

  -- Filtro para Doctos Listados no Grid
  if @cd_doc_receber <> ''
    set @instrucaoSQL = @instrucaoSQL + ' AND D.CD_IDENTIFICACAO LIKE '+''''+@cd_doc_receber+'%'''

  if @ic_ordem = 'V'  -- vencimento
    set @InstrucaoSQL = @InstrucaoSQL + ' ORDER BY CG.NM_CLIENTE_GRUPO, D.DT_VENCIMENTO_DOCUMENTO '

  if @ic_ordem = 'E'  -- emissão
    set @InstrucaoSQL = @InstrucaoSQL + ' ORDER BY CG.NM_CLIENTE_GRUPO, D.DT_EMISSAO_DOCUMENTO '

  if @ic_ordem = 'C'  -- cliente
    set @InstrucaoSQL = @InstrucaoSQL + ' ORDER BY CG.NM_CLIENTE_GRUPO, C.NM_RAZAO_SOCIAL_CLIENTE '

  --print(@InstrucaoSQL)

  exec(@InstrucaoSQL)

    
