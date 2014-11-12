
create procedure pr_renumerar_rem
@dt_inicial datetime

as

  declare @NotaEntrada int
  declare @Fornecedor int
  declare @CFOP int
  declare @Serie int
  declare @Receb datetime
  declare @REM int


  -- CARREGA O REM IMEDIATAMENTE ANTERIOR PARA DAR INÍCIO A CONTAGEM
  select
    @REM = isnull(max(ner.cd_rem),0)
  from
    nota_entrada_registro ner,
    nota_entrada ne
  where
    ne.cd_nota_entrada = ner.cd_nota_entrada and
    ne.cd_fornecedor = ner.cd_fornecedor and
    ne.cd_operacao_fiscal = ner.cd_operacao_fiscal and
    ne.cd_serie_nota_fiscal = ner.cd_serie_nota_fiscal and
    ne.dt_receb_nota_entrada < @dt_inicial

      
  -- CARREGA TODAS AS NOTAS FISCAIS A SEREM RENUMERADAS

  declare cRenumerarRem cursor for  
  select
    ne.cd_nota_entrada,
    ne.cd_fornecedor,
    ne.cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal,
    ne.dt_receb_nota_entrada
  from
    Nota_Entrada ne
  left outer join
    Operacao_Fiscal op
  on
    op.cd_operacao_fiscal = ne.cd_operacao_fiscal  
  where
    ne.dt_receb_nota_entrada >= @dt_inicial
  order by
    ne.dt_receb_nota_entrada,
    op.cd_mascara_operacao

  open cRenumerarRem 

  fetch next from cRenumerarRem into @NotaEntrada, @Fornecedor, @CFOP, @Serie, @Receb

  while @@fetch_status = 0
  begin

    set @REM = @REM + 1

    print('NF '+cast(@NotaEntrada as varchar)+
          ' Fornecedor '+cast(@Fornecedor as varchar)+
          ' Serie '+cast(@Serie as varchar)+
          ' CFOP '+cast(@CFOP as varchar)+
          ' Receb '+cast(@Receb as varchar)+
          ' REM '+cast(@REM as varchar))

    update nota_entrada_item_registro
    set cd_rem = @REM,
        cd_item_rem = isnull(cd_item_registro_nota,cd_item_rem)
    where cd_nota_entrada = @NotaEntrada and
          cd_fornecedor = @Fornecedor and
          cd_operacao_fiscal = @CFOP and
          cd_serie_nota_fiscal = @Serie

    update nota_entrada_registro
    set cd_rem = @REM
    where cd_nota_entrada = @NotaEntrada and
          cd_fornecedor = @Fornecedor and
          cd_operacao_fiscal = @CFOP and
          cd_serie_nota_fiscal = @Serie

    update nota_entrada
    set cd_rem = @REM
    where cd_nota_entrada = @NotaEntrada and
          cd_fornecedor = @Fornecedor and
          cd_operacao_fiscal = @CFOP and
          cd_serie_nota_fiscal = @Serie
    
    fetch next from cRenumerarRem into @NotaEntrada, @Fornecedor, @CFOP, @Serie, @Receb

  end

  close cRenumerarRem
  deallocate cRenumerarRem




--select * from nota_entrada_item_registro where cd_nota_entrada = 7019
  
