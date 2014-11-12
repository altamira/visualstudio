
-------------------------------------------------------------------------------
--pr_calculo_orcamento_produto_estampo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cálculo do Orçamento dos Produto Estampados
--Data             : 29.04.2007
--Alteração        : 30.04.2007
--                 : 07.05.2007
--                 : 05.12.2007 - Verificação dos Cálculos/Acertos - Carlos Fernandes
--                 : 06.12.2007 - Utiliza os valores do Markup conforme nova tabela
--                                Produto_Estampo - Carlos Fernandes.                                  
-- 11.02.2008 - Revisão - Carlos Fernandes
-------------------------------------------------------------------------------------
create procedure pr_calculo_orcamento_produto_estampo
@cd_produto_estampo  int      = 0,
@dt_base             datetime = null,
@cd_tipo_lucro       int      = 0,
@cd_aplicacao_markup int      = 0
as

declare @qt_dia_util   as integer  
declare @dt_agenda     as datetime

if @dt_base is null
begin
  set @dt_base = getdate()
end

set @dt_agenda = @dt_base

if @dt_base>getdate()
begin
  set @dt_agenda = getdate()
end

set @qt_dia_util = ( select count(dt_agenda) from Agenda   
                      where month(dt_agenda) = month(@dt_agenda) and  
                      year(dt_agenda) = year(@dt_agenda) and  
                       isnull(ic_util,'N') = 'S')  

--Somente para Teste
--set @qt_dia_util = 20

--select @qt_dia_util


--select * from produto_estampo
--select * from grupo_orcamento
--select * from categoria_orcamento
--select * from categoria_orcamento_composicao
--select * from materia_prima
--select * from sucata
--select * from tipo_calculo_orcamento

select
  go.cd_grupo_orcamento,
  go.nm_grupo_orcamento,
  go.cd_masc_grupo_orcamento,
  co.cd_categoria_orcamento,
  co.nm_categoria_orcamento,
  co.cd_mascara_cat_orcamento,
  cast(0.00 as decimal(25,2)) as vl_custo_produto,
  cast(0.00 as decimal(25,2)) as vl_custo_kg,
  cast(0.00 as decimal(25,2)) as pc_categoria,

  cast(case when go.cd_tipo_calculo_orcamento = 3  -- Componente/MP
  then
    ((pe.vl_custo_materia_prima * pe.qt_blank_produto)/1000)-
    ((pe.vl_custo_sucata * pe.qt_sucata_produto)/1000)
  else 
    case when go.cd_tipo_calculo_orcamento = 4     --Ferramental
    then
      (pe.vl_ferramental_produto/pe.qt_producao)
    else 
      case when go.cd_tipo_calculo_orcamento = 5     --Frete
      then
        (pe.vl_frete_produto/pe.qt_producao)
      else 
        case when go.cd_tipo_calculo_orcamento = 6     --Tratamento
         then
            pe.vl_tratamento_produto/pe.qt_produto_kg
         else 
           case when go.cd_tipo_calculo_orcamento = 7     --Acabamento
            then
              pe.vl_acabamento_produto/pe.qt_produto_kg
            else 0.00 end
         end
      end
    end 
  end as decimal(25,6))                        as Custo, 

  pe.qt_blank_produto,
  pe.qt_sucata_produto,
  pe.vl_custo_materia_prima,
  pe.vl_custo_sucata,
  pe.vl_ferramental_produto,
  pe.vl_frete_produto,
  pe.vl_tratamento_produto,
  pe.vl_acabamento_produto,
  pe.qt_produto_kg,

  --Cálculo da Mão-Obra

  cast((case when isnull(coc.ic_base_dia_util_categoria,'N')='S'
  then
    isnull(coc.vl_categoria_orcamento,0)/(case when @qt_dia_util>0 then @qt_dia_util else 1 end )
  else
    isnull(coc.vl_categoria_orcamento,0)
  end)

  /

  ( case when isnull(coc.ic_producao_diaria,'N')='S'
    then
      case when isnull(pe.qt_producao_diaria,0)>0 then pe.qt_producao_diaria else 1 end
    else
      case when isnull(coc.ic_producao_orcamento,'N')='S'
      then
         case when isnull(pe.qt_producao,0)>0 then pe.qt_producao else 1 end
      else 
         case when isnull(coc.ic_peso_orcamento,'N')='S' then
           case when isnull(pe.qt_produto_kg,0)>0 then pe.qt_produto_kg else 1 end
         else 1 end
      end
    end ) as decimal(25,6))    

                                                        as MaoObra,

    isnull(coc.ic_valor_total,'N')                      as ConsideraTotal,
    @qt_dia_util                                        as DiasUteis

into
  #Orcamento
from
  grupo_orcamento go with (nolock)
  left outer join categoria_orcamento co             on co.cd_grupo_orcamento      = go.cd_grupo_orcamento
  left outer join categoria_orcamento_composicao coc on coc.cd_categoria_orcamento = co.cd_categoria_orcamento
  left outer join produto_estampo     pe             on pe.cd_produto_estampo      = @cd_produto_estampo

where
  isnull(go.ic_ativo_grupo_orcamento,'N')='S'


--Cálculo do Preço de Venda

declare @vl_custo_total      float
declare @pc_tipo_lucro       float

--Parâmetros do Orçamento para aplicação do Markup / Tipo de Lucro

select
  @cd_aplicacao_markup = isnull(cd_aplicacao_markup,@cd_aplicacao_markup),
  @cd_tipo_lucro       = isnull(cd_tipo_lucro,@cd_tipo_lucro)
from
  parametro_orcamento_estampo
where
  cd_empresa = dbo.fn_empresa()

--Tipo de Lucro
--select * from tipo_lucro

set @pc_tipo_lucro = 0.00

if @cd_tipo_lucro<>0
begin
  select
    @pc_tipo_lucro = isnull(pc_tipo_lucro,0)/100
  from
    Tipo_Lucro
  where
    cd_tipo_lucro = @cd_tipo_lucro
end

--Valor Total de Custo

select
  @vl_custo_total    = sum( isnull(case when Custo>0 then Custo else MaoObra end  ,0) )
from
  #Orcamento  

------------------------------------------------------------------------------------
--Cálculo do preço de venda unitário final
------------------------------------------------------------------------------------

update
  produto_estampo
set
  vl_produto            = round(@vl_custo_total / dbo.fn_indice_markup_estampo( @cd_aplicacao_markup, @cd_tipo_lucro, @cd_produto_estampo),5), 
  vl_cento_produto      = round(vl_produto       * 100,5),
  vl_milheiro_produto   = round(vl_produto       * 1000,5),
  vl_total_produto      = qt_producao      * vl_produto,
  vl_lucro_produto      = vl_total_produto * @pc_tipo_lucro,
  vl_referencia_produto = vl_produto       * qt_produto_kg,
  cd_tipo_lucro         = @cd_tipo_lucro,
  cd_aplicacao_markup   = @cd_aplicacao_markup,
  vl_orcamento_produto  = vl_produto,
  vl_produto_estampo    = vl_produto
where
  cd_produto_estampo    = @cd_produto_estampo

------------------------------------------------------------------------------------
--Atualiza a Tabela de Produto como o valor do Produto
------------------------------------------------------------------------------------
declare @cd_produto int
declare @vl_produto float

set @cd_produto = 0
set @vl_produto = 0

select
  @cd_produto = isnull(cd_produto,0),
  @vl_produto = isnull(vl_produto,0)
from
  Produto_Estampo
where
  cd_produto_estampo    = @cd_produto_estampo

if @cd_produto>0
begin

  update
    produto
  set
    vl_produto = @vl_produto
  where
    cd_produto = @cd_produto

end 
------------------------------------------------------------------------------------



------------------------------------------------------------------------------------
--Mostra a tabela Final com o Cálculo do Orçamento
------------------------------------------------------------------------------------

select 
  cd_grupo_orcamento,
  nm_grupo_orcamento,
  cd_masc_grupo_orcamento,
  cd_categoria_orcamento,
  nm_categoria_orcamento,
  cd_mascara_cat_orcamento,
  Custo,
  MaoObra,

  ( case when custo>0 then custo else maoobra end )                 as vl_custo_produto,

  cast(
  ( case when custo>0 then custo else maoobra end ) * qt_produto_kg 
  as decimal(25,6))                                                 as vl_custo_kg,

  ((case when custo>0 then custo else maoobra end ) / @vl_custo_total)*100   

                                                                    as pc_categoria,

  dbo.fn_indice_markup_estampo( @cd_aplicacao_markup, @cd_tipo_lucro, @cd_produto_estampo) 
                                                                    as Markup,
  @pc_tipo_lucro*100                                                as pc_lucro,
  DiasUteis

from 
  #Orcamento

