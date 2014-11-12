
CREATE FUNCTION fn_get_ipi_produto

(@cd_produto int)        	--Código do produto recebido

RETURNS float

AS
BEGIN

  declare @ic_isento_ipi_produto char(1)
  declare @pc_ipi                float

  set @pc_ipi = 0.00

  Select 
    @ic_isento_ipi_produto     = isnull(ic_isento_ipi_produto,'N')
  from
    parametro_produto with (nolock) 
  where
    cd_empresa = dbo.fn_empresa()

  if @ic_isento_ipi_produto = 'N'
  begin

    --Consultando ipi pela tabela de Produto_Fiscal

    select
      @pc_ipi = isnull(cf.pc_ipi_classificacao,0)
    from
      Classificacao_Fiscal cf           with (nolock) 
      left outer join Produto_Fiscal pf with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
    where
      pf.cd_produto = @cd_produto

    if isnull(@pc_ipi, 0) = 0
    begin
      --Consultando na tabela Grupo_Produto_Fiscal
      select
        @pc_ipi = isnull(cf.pc_ipi_classificacao,0)
      from
        Classificacao_Fiscal cf                  with (nolock) 
        left outer join Grupo_Produto_Fiscal gpf with (nolock) on cf.cd_classificacao_fiscal = gpf.cd_classificacao_fiscal
        left outer join Produto p                with (nolock) on p.cd_grupo_produto = gpf.cd_grupo_produto
      where
        p.cd_produto = @cd_produto    

    end  

    if isnull(@pc_ipi, 0) = 0
    begin
      --Consultando na tabela Serie_Produto_Categoria
      select
        @pc_ipi = isnull(cf.pc_ipi_classificacao,0)
      from
        Classificacao_Fiscal cf                     with (nolock) 
        left outer join Serie_Produto_Categoria spc with (nolock) on cf.cd_classificacao_fiscal = spc.cd_classificacao_fiscal
        left outer join Produto p                   with (nolock) on p.cd_serie_produto         = spc.cd_serie_produto

      where
        p.cd_produto = @cd_produto    

    end  

  end

  --Retorna o percentual de ipi

  RETURN (isnull(@pc_ipi, 0))

END


-------------------------------------------------------------------------------------------
--Example to execute function
-------------------------------------------------------------------------------------------
--Select * form fn_get_IPI_Produto 
