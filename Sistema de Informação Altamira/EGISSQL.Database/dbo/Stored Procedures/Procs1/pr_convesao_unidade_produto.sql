
-------------------------------------------------------------------------------
--pr_convesao_unidade_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 06/02/2005
--Atualizado       : 06/02/2005
--------------------------------------------------------------------------------------------------
create procedure pr_convesao_unidade_produto
@cd_produto        int,
@cd_unidade_origem int,
@qt_produto        float,
@vl_custo          float
as

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

select
  @cd_unidade_origem                as cd_unidade_origem,
  umo.sg_unidade_medida             as UnidadeOrigem,
  @qt_produto                       as QtdOrigem,
  @vl_custo                         as CustoOrigem,
  @ic_sinal_conversao               as Conversao,
  @qt_fator_produto_unidade         as Fator,
  um.cd_unidade_medida,
  um.sg_unidade_medida              as UnidadeConvertida,
  isnull(@qt_produto_convertida,0)  as QtdConvertida,
  @vl_custo_convertido              as CustoConvertido
from
  Unidade_Medida um
  left outer join Unidade_Medida umo on umo.cd_unidade_medida = @cd_unidade_origem
where
  um.cd_unidade_medida = @cd_unidade_medida
