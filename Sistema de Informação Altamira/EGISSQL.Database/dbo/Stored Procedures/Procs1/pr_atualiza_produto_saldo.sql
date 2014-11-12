CREATE PROCEDURE pr_atualiza_produto_saldo
@ic_parametro                int, 
@cd_tipo_movimento_estoque   int,
@cd_produto                  int,
@cd_fase_produto             int,
@qt_produto_atualizacao      float

AS
declare @SQL                       varchar(1000)
declare @ic_tipo_calculo           char(1)
declare @vl_tipo_atualizacao       int
declare @nm_atributo               char (30)

set  @SQL                       = ''
set  @ic_tipo_calculo           = ''
set  @vl_tipo_atualizacao       = 0
set  @nm_atributo               = ''
-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Atualização do Saldo do Produto
-------------------------------------------------------------------------------
-- Busca o Tipo de Calculo E/S
  begin
    select 
     @ic_tipo_calculo = tme.ic_mov_tipo_movimento,
     @nm_atributo     = tme.nm_atributo_produto_saldo
    from 
      tipo_movimento_estoque tme
    where 
      tme.cd_tipo_movimento_estoque = @cd_tipo_movimento_estoque

    -- Atualiza Saldo do Produto no Estoque
    if @ic_tipo_calculo = 'E' 
      set @vl_tipo_atualizacao = 1
    else
      set @vl_tipo_atualizacao = -1  

    set @SQL = ' update produto_saldo set ' + @nm_atributo + 
               ' = isnull (' + @nm_atributo + ',0) + 
               (' + convert (varchar (15),@qt_produto_atualizacao) + '*' +  convert (varchar (15),@vl_tipo_atualizacao)+ '),' +
               ' dt_atual_produto = getdate() ' +
               ' where cd_produto = ' + convert (varchar (15),@cd_produto) + ' and ' +
               ' cd_fase_produto = '+ convert (varchar (15),@cd_fase_produto)
     
    exec(@SQL)

  end



