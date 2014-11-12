-------------------------------------------------------------------------------
--fn_comissao_margem_contribuicao
-------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                                      2004
-------------------------------------------------------------------------------
--Stored Procedure        : Microsoft Sql Server 2000
--Autor(es)               : Carlos Cardoso Fernandes
--Banco de Dados          : EgisSql ou Egisadmin
--Objetivo                : 
--Data                    : 15/12/2004
--Atualização             : Acerto do Cabeçalho - Sérgio Cardoso
--                        : 08.01.2005 - Carlos Fernandes 
-------------------------------------------------------------------------------
create function fn_comissao_margem_contribuicao
(@vl_margem_contribuicao decimal(25,2))

returns decimal(25,2)

as
begin

-- 1 - Verificar qual a faixa da margem de contribuição, para isso
--     é necessário encontrar qual a faixa que mais de aproxima, tipo:
--     valor = 0.68 é igual a margem 5 que é 0.69 e não a margem 6 que
--     é 0.64

declare @pc_comissao  decimal(25,2)
declare @vl_diferenca decimal(25,2)

select top 1 @pc_comissao  = pc_comissao,
             @vl_diferenca = @vl_margem_contribuicao - cast(vl_margem_contribuicao as decimal(25,2))
from 
  comissao_margem_contribuicao
where 
  cast(vl_margem_contribuicao as decimal(25,2)) <= @vl_margem_contribuicao
order by 
  cast(vl_margem_contribuicao as decimal(25,2)) desc

--Verifica se foi localizado um (%) para comissão

if @pc_comissao is null or @pc_comissao = 0
begin
  select top 1
    @pc_comissao = pc_comissao
  from
    comissao_margem_contribuicao
  order by 
    cast(vl_margem_contribuicao as decimal(25,2)) asc 
  
end

if @vl_diferenca > (select top 1 cast(vl_margem_contribuicao as decimal(25,2)) - @vl_margem_contribuicao
                     from 
                       comissao_margem_contribuicao
                     where  
                       cast(vl_margem_contribuicao as decimal(25,2)) >= @vl_margem_contribuicao
                     order by 
                       cast(vl_margem_contribuicao as decimal(25,2)) asc )
begin

  select top 1 @pc_comissao = pc_comissao
  from 
    comissao_margem_contribuicao
  where 
    cast(vl_margem_contribuicao as decimal(25,2)) >= @vl_margem_contribuicao
  order by 
    cast(vl_margem_contribuicao as decimal(25,2)) asc

end

return isnull(@pc_comissao,0)

end

