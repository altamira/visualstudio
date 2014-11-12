create function fn_conversao_unidade_medida
( @cd_produto        int,
  @cd_unidade_origem int,
  @qt_produto        float,
  @vl_custo          float ) returns float
-------------------------------------------------------------------------------
--fn_conversao_unidade_medida
-------------------------------------------------------------------------------
--GBS - Global Business Solution  LTDA          	                   2004
-------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Fernandes / Robson
--Banco de Dados	: EGISSQL
--Objetivo		: Conversão de Unidade de Medida
--Data			: 01.09.2005
--Alteração             : 01.09.2005
-------------------------------------------------------------------------------
as
Begin

--select * from produto_unidade_medida

declare @qt_produto_convertida    float
declare @qt_fator_produto_unidade float
declare @ic_sinal_conversao       char(1)
declare @cd_unidade_medida        int
declare @vl_custo_convertido      float

set @qt_produto_convertida = 0
set @vl_custo_convertido   = 0

-- Verifica se foi passado um produto válido

if isnull(@cd_produto,0)>0 
begin

  --Busca o Fator e o Sinal de Conversao

  select
    @qt_fator_produto_unidade = qt_fator_produto_unidade,
    @ic_sinal_conversao       = ic_sinal_conversao,
    @cd_unidade_medida        = cd_unidade_destino
  from
    Produto_Unidade_Medida
  where
    cd_produto        = @cd_produto and
    cd_unidade_origem = @cd_unidade_origem

   --Conversão

   if @qt_produto<>0 and @qt_fator_produto_unidade<>0
   begin
     --Multiplicação  
     if @ic_sinal_conversao='*' 
     begin
        set @qt_produto_convertida = @qt_produto * @qt_fator_produto_unidade
        set @vl_custo_convertido   = ( @vl_custo   / @qt_produto_convertida )
     end

     --Divisão
     if @ic_sinal_conversao='/' 
     begin
        set @qt_produto_convertida = @qt_produto / @qt_fator_produto_unidade
        set @vl_custo_convertido   = ( @vl_custo   * @qt_produto ) / @qt_produto_convertida
     end
     --Adição
     if @ic_sinal_conversao='+' 
     begin
        set @qt_produto_convertida = @qt_produto + @qt_fator_produto_unidade
     end
     --Subtração
     if @ic_sinal_conversao='-' 
     begin
        set @qt_produto_convertida = @qt_produto - @qt_fator_produto_unidade    
    end  

   end

end


  return cast(IsNull(@qt_produto_convertida,0) as decimal (15,2))

end
