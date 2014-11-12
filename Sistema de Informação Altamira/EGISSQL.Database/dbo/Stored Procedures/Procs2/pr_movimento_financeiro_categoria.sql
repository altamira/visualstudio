
CREATE  PROCEDURE pr_movimento_financeiro_categoria
@ic_parametro            int = 0,  --0 = Consulta   1=Retorno do Valor
@cd_categoria_financeiro int = 0,
@dt_inicial              datetime,
@dt_final                datetime,
@ic_tipo                 int = 0
as


--select * from categoria_financeiro  
--select * from plano_financeiro_movimento  
--select * from plano_financeiro  

select  
  cf.cd_categoria_financeiro,  
  max(cf.nm_categoria_financeiro)        as nm_categoria_financeiro,  
  max(pf.nm_conta_plano_financeiro)      as nm_conta_plano_financeiro,  
  sum(isnull(pfm.vl_plano_financeiro,0)) as vl_plano_financeiro
  --isnull(sum(pfm.vl_plano_financeiro),0) as tl_plano_financeiro
  --isnull(pfm.vl_plano_financeiro / isnull(sum(pfm.vl_plano_financeiro),0)* 100,0) as Perc  
    
into #AuxCategoria  
from  
  Categoria_Financeiro cf  
  left outer join Plano_Financeiro pf            on pf.cd_categoria_financeiro = cf.cd_categoria_financeiro  
  left outer join Plano_Financeiro_Movimento pfm on pfm.cd_plano_financeiro    = pf.cd_plano_financeiro    
where  
  cf.cd_categoria_financeiro = case when @cd_categoria_financeiro = 0 then cf.cd_categoria_financeiro else @cd_categoria_financeiro end  and
  pfm.dt_movto_plano_financeiro between @dt_inicial and @dt_final and   
  pfm.cd_tipo_lancamento_fluxo = case when @ic_tipo = 0 then pfm.cd_tipo_lancamento_fluxo else @ic_tipo end  

group by  
  cf.cd_categoria_financeiro,  
  pf.nm_conta_plano_financeiro

declare @vl_total float

select
  @vl_total = sum( isnull(vl_plano_financeiro,0) )
from
  #AuxCategoria  

select
  *,
  Perc = ( vl_plano_financeiro / @vl_total ) * 100 
into
  #AuxCategoriaResultado
from
  #AuxCategoria

--select * from #AuxCategoria  

if @ic_parametro = 0
begin
  select * from #AuxCategoriaResultado order by cd_categoria_financeiro
end
else
begin
  declare @cd_categoria            int
  declare @vl_plano_financeiro     float

  while exists ( select top 1 cd_categoria_financeiro from  #AuxCategoriaResultado )
  begin
    select top 1
      @cd_categoria        = cd_categoria_financeiro,
      @vl_plano_financeiro = isnull(vl_plano_financeiro,0)
    from 
      #AuxCategoriaResultado

    --Atualização do valor
    update
      Categoria_Financeiro
    set
      vl_categoria_financeiro = isnull(@vl_plano_financeiro,0)
    where
      cd_categoria_financeiro = @cd_categoria

    delete from #AuxCategoriaResultado where cd_categoria_financeiro = @cd_categoria

  end

end


