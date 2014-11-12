  
CREATE FUNCTION fn_serie_documento_receber
(@cd_nota_saida varchar(25),
 @dt_emissao    datetime,
 @ic_parametro  char(1),     --'N' > Nota Saida / 'P' > Pedido de Venda / M - Manual
 @qt_parcela    int = 1  )   --Quantidade de Parcela
RETURNS varchar(25)


AS
BEGIN 

  -- declarações de variáveis
  declare @ic_serie_doc_rec_empresa char(1)  -- tipo de série (L)etra ou (N)úmero
  declare @ic_ano_doc_rec_empresa   char(1)  -- gravar último dígito do ano na série (S/N)
  declare @ic_1parc_doc_rec_empresa char(1)  -- 1º parcela contém série (S/N)
  declare @ic_zera_primeira_parcela char(1)  -- Verifica se a primeira parcela começa com zero
  declare @ic_numera_parcela        char(1)  -- Numeração de Parcela somente para Parcela > 1

  declare @cd_identificacao     varchar(25)
  declare @cd_1digito           varchar(3)
  declare @cd_2digito           varchar(3)
  declare @cd_serie             varchar(9)
  declare @ic_primeira_parcela  char(1)
  declare @dt_hoje		datetime

  -- carrega os parâmetros  
  select top 1
    @ic_serie_doc_rec_empresa = ic_serie_doc_rec_empresa,
    @ic_ano_doc_rec_empresa   = ic_ano_doc_rec_empresa,
    @ic_1parc_doc_rec_empresa = ic_1parc_doc_rec_empresa,
    @ic_zera_primeira_parcela = ic_zero_primeira_parcela,
    @ic_numera_parcela        = isnull(ic_numera_parcela,'N')
  from
    Parametro_Financeiro with (nolock) 
  where
    cd_empresa = dbo.fn_empresa()  

  -- carrega parametros default quando não existentes em parametro_financeiro
  if (@ic_serie_doc_rec_empresa is null)
  begin
    set @ic_serie_doc_rec_empresa = 'L'   -- Série por Letra
  end

  if (@ic_ano_doc_rec_empresa is null)
    set @ic_ano_doc_rec_empresa = 'N'     -- Não Guarda o Ano

  if (@ic_1parc_doc_rec_empresa is null)
    set @ic_1parc_doc_rec_empresa = 'S'   -- Guarda a Série na 1º Parcela
  
---------------------------------------------------------------------------------------------
if @ic_parametro = 'N'
---------------------------------------------------------------------------------------------
begin
  -- localiza a última identificação correspondente com a nota de saída
  -- existente na Nota_Saida_Parcela - ELIAS - 20/05/2003

  select top 1
    @cd_1digito = substring(nsp.cd_ident_parc_nota_saida, patindex('%-%', nsp.cd_ident_parc_nota_saida)+1, 1),
    @cd_2digito = substring(nsp.cd_ident_parc_nota_saida, patindex('%-%', nsp.cd_ident_parc_nota_saida)+2, 1)
  from
    Nota_Saida_Parcela nsp   with (nolock) 
    inner join Nota_Saida ns with (nolock) on ns.cd_nota_saida = nsp.cd_nota_saida
  where
    ns.cd_identificacao_nota_saida = @cd_nota_saida
    --cd_ident_parc_nota_saida like right('000000'+cast(@cd_nota_saida as varchar(6)),6)+'%'
  order by 
    cd_parcela_nota_saida desc
 
end

---------------------------------------------------------------------------------------------
if @ic_parametro = 'P'
---------------------------------------------------------------------------------------------
begin
  -- localiza a última identificação correspondente com o pedido de venda
  -- existente na Pedido_Venda_Parcela - Johnny - 22/05/2003
  select top 1
    @cd_1digito = substring(cd_ident_parc_ped_venda, patindex('%-%', cd_ident_parc_ped_venda)+1, 1),
    @cd_2digito = substring(cd_ident_parc_ped_venda, patindex('%-%', cd_ident_parc_ped_venda)+2, 1)
--    @qt_parcela = count(*)

  from
    Pedido_Venda_Parcela
  where
    cd_ident_parc_ped_venda like right('000000'+cast(@cd_nota_saida as varchar(6)),6)+'%'
  order BY cd_parcela_ped_venda Desc

end
---------------------------------------------------------------------------------------------
if @ic_parametro = 'S'
---------------------------------------------------------------------------------------------
begin
  -- localiza a última identificação correspondente com o pedido de venda
  -- existente na Pedido_Venda_Parcela - Johnny - 22/05/2003
  select top 1
    @cd_1digito = substring(cd_ident_parc_ord_serv, patindex('%-%', cd_ident_parc_ord_serv)+1, 1),
    @cd_2digito = substring(cd_ident_parc_ord_serv, patindex('%-%', cd_ident_parc_ord_serv)+2, 1)
--    @qt_parcela = count(*)

  from
    Ordem_Servico_Parcela
  where
    cd_ident_parc_ord_serv like right('000000'+cast(@cd_nota_saida as varchar(6)),6)+'%'
  Order BY cd_parcela_ord_serv Desc


end
---------------------------------------------------------------------------------------------
if @ic_parametro = 'M' --Manual
---------------------------------------------------------------------------------------------
begin
    set @cd_1digito = substring(@cd_nota_saida, patindex('%-%', @cd_nota_saida)+1, 1)
    set @cd_2digito = substring(@cd_nota_saida, patindex('%-%', @cd_nota_saida)+2, 1)
end

---------------------------------------------------------------------------------------------

  -- se não retornou nenhum dígito significa que é a primeira parcela

  if ((@cd_1digito is null) and (@cd_2digito is null))
    set @ic_primeira_parcela = 'S'
  else
    set @ic_primeira_parcela = 'N'    

  -- se a série a ser guardada é Letra

  if @ic_serie_doc_rec_empresa = 'L' 
    begin

      -- inicializa os dígitos caso não retorne nada
      if @cd_1digito is null 
        set @cd_1digito = char(64)

      -- verifica se o dígito antigo era uma letra, então incrementa
      if ((ascii(@cd_1digito) >= 65) and (ascii(@cd_1digito) <= 90))
        -- char(65) = 'A'
        -- char(90) = 'Z'
        begin

          -- se superar a letra 'Z' retornar a letra 'A' (por enquanto)
          if (ascii(@cd_1digito)+1) > 90
            set @cd_1digito = char(65)
          else
            set @cd_1digito = char(ascii(@cd_1digito)+1)

        end
      else
        -- se o antigo era número passar a numerar como letra
        set @cd_1digito = char(65)

     -- se for a primeira parcela c/ letra colocar '0'
     if ( @ic_primeira_parcela = 'S' ) and ( @ic_zera_primeira_parcela = 'S' )
       set @cd_1digito = '0'

     if (@ic_numera_parcela ='S') and @qt_parcela=1
     begin
       set @cd_1digito = ''
--       print @cd_1digito
     end

    end
  else
    -- quando a série guardada é número
    begin

      -- inicializa os dígitos caso não retorne nada
      if @cd_1digito is null 
        set @cd_1digito = char(47)

      -- verifica se o dígito antigo era um número, senão incrementa
      if ((ascii(@cd_1digito) >= 48) and (ascii(@cd_1digito) <= 57))
        begin
          -- char(48) = '0'
          -- char(57) = '9'

          -- se superar o número '0' retornar a '9' (por enquanto)
          if (ascii(@cd_1digito)+1) > 57
            set @cd_1digito = char(48)
          else
            set @cd_1digito = char(ascii(@cd_1digito)+1)

        end
      else
        -- se o antigo era letra passar a númerar como número
        set @cd_1digito = char(48)

    end

  -- define se vai guardar ou não o ano na série
  if @ic_ano_doc_rec_empresa = 'S'
    set @cd_2digito = right(datepart(yy, @dt_emissao), 1)
  else
    set @cd_2digito = ''

  -- define se irá retornar o ano na série

  --Antes de 04.05.2009 - Todos os Clientes 
  --set @cd_serie = right('000000'+cast(@cd_nota_saida as varchar(6)),6)
  --set @cd_serie = right('0000000'+cast(@cd_nota_saida as varchar(7)),7)

  set @cd_serie = right(''+cast(@cd_nota_saida as varchar(7)),7)

  if @ic_1parc_doc_rec_empresa = 'S'
  begin
    if @cd_1digito<>'' 
       set @cd_serie = @cd_serie +'-'+@cd_1digito 

    if @cd_2digito<>''
       set @cd_serie = @cd_serie + @cd_2digito 

  end
  else
    begin

      -- não retornar nada caso seja a primeira parcela e o parametro = 'N'
      if @ic_primeira_parcela = 'S'
        set @cd_serie = @cd_serie + ''
      else
        begin
          if @cd_1digito<>'' 
             set @cd_serie = @cd_serie +'-'+@cd_1digito 

          if @cd_2digito<>''
             set @cd_serie = @cd_serie + @cd_2digito 

        end 
    end

  --Retorno do Valor da Identificação da Parcela      
  return(@cd_serie)

--  return(@cd_1digito)

end
   
  
