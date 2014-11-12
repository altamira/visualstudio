
-------------------------------------------------------------------------------
--sp_helptext pr_diario_entrega
-------------------------------------------------------------------------------
--pr_diario_entrega
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes / Douglas de Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : Diário de Entregas
--Data             : 20.10.2008
--Alteração        : 21.10.2008 
--
--
------------------------------------------------------------------------------
create procedure pr_diario_entrega
@ic_parametro int      = 0,
@dt_base      datetime = '',
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@grupo        datetime = 1,
@cd_motorista int      = 0,
@cd_veiculo   int      = 0
as
   select
     ns.cd_veiculo,
     ns.cd_motorista,
     ns.cd_condicao_pagamento,
     ns.cd_nota_saida as cd_nota_saida,
     ns.dt_nota_saida as dt_nota_saida,
     ns.vl_total as vl_total,
     v.nm_veiculo as nm_veiculo,
     m.nm_motorista as nm_motorista,
     fp.sg_forma_pagamento,
     ve.nm_fantasia_vendedor,
     c.nm_fantasia_cliente,
     c.nm_endereco_cliente + ', ' + c.cd_numero_endereco as endereco,
     c.nm_bairro,
     c.cd_ddd + ' ' + cd_telefone as telefone,
     0.00 as vl_avista,
     0.00 as vl_aprazo,
     0.00 as PERC
   into
     #Nota   
   from
     Nota_Saida                         ns with (nolock)  
     left outer join Veiculo            v  with (nolock) on v.cd_veiculo             = ns.cd_veiculo
     left outer join Motorista          m  with (nolock) on m.cd_motorista           = ns.cd_motorista
     left outer join condicao_pagamento cp with (nolock) on cp.cd_condicao_pagamento = ns.cd_condicao_pagamento
     left outer join forma_pagamento    fp with (nolock) on fp.cd_forma_pagamento    = ns.cd_forma_pagamento 
     left outer join vendedor           ve with (nolock) on ve.cd_vendedor           = ns.cd_vendedor
     left outer join cliente            c  with (nolock) on c.cd_cliente             = ns.cd_cliente 
   where
     ns.dt_nota_saida between @dt_inicial and @dt_final and
     ns.cd_status_nota <> 7 and 
     ns.cd_motorista = case when isnull(@cd_motorista,0) = 0 then ns.cd_motorista else isnull(@cd_motorista,0) end and
     ns.cd_veiculo   = case when isnull(@cd_veiculo,0)   = 0 then ns.cd_veiculo   else isnull(@cd_veiculo,0)   end 

select *  into #Nota2 from #Nota where dt_nota_saida = case when isnull(@dt_base,0) = 0 then dt_nota_saida else @dt_base end 

if @ic_parametro = 1
begin

declare @sql1 varchar(200)
declare @sql2 varchar(200)
set @sql2 = 'select ' 
set @sql1 = ' max(cd_nota_saida) as cd_nota_saida, max(dt_nota_saida) as dt_nota_saida, ' +
            'sum(vl_total) as vl_total, max(nm_veiculo) as nm_veiculo, max(nm_motorista) as nm_motorista from #Nota2 n group by ' 

if @grupo = 1
  begin
    EXEC(@sql2 + 'cd_motorista, max(cd_veiculo) as cd_veiculo, ' + 
                 '(select sum(vl_total) from #nota2 where cd_motorista = n.cd_motorista and cd_condicao_pagamento = 1) as vl_avista, ' +
                 '(select sum(vl_total) from #nota2 where cd_motorista = n.cd_motorista and cd_condicao_pagamento <> 1) as vl_aprazo,' +
                 '(sum(n.vl_total)/(select sum(vl_total) from #nota2)*100) as PERC, ' +
         @sql1 + 'cd_motorista')
  end
else if @grupo = 2
  begin
    EXEC(@sql2 + 'max(cd_motorista) as cd_motorista, cd_veiculo,' + 
                 '(select sum(vl_total) from #nota2 where cd_veiculo = n.cd_veiculo and cd_condicao_pagamento = 1) as vl_avista, ' +
                 '(select sum(vl_total) from #nota2 where cd_veiculo = n.cd_veiculo and cd_condicao_pagamento <> 1) as vl_aprazo,' +
                 '(sum(n.vl_total)/(select sum(vl_total) from #nota2)*100) as PERC, ' +
         @sql1 + 'cd_veiculo')
  end
else
  begin
    EXEC(@sql2 + 'cd_motorista, cd_veiculo,' + 
                 '(select sum(vl_total) from #nota2 where cd_veiculo = n.cd_veiculo and cd_motorista = n.cd_motorista and cd_condicao_pagamento = 1) as vl_avista, ' +
                 '(select sum(vl_total) from #nota2 where cd_veiculo = n.cd_veiculo and cd_motorista = n.cd_motorista and cd_condicao_pagamento <> 1) as vl_aprazo,' +
                 '(sum(n.vl_total)/(select sum(vl_total) from #nota2)*100) as PERC, ' +
         @sql1 + 'cd_motorista, cd_veiculo')
  end  

end
else 
  begin
    select * from #nota2
  end

