
-------------------------------------------------------------------------------
--sp_helptext pr_atualiza_funcionario_dependente
-------------------------------------------------------------------------------
--pr_atualiza_funcionario_dependente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Atualização do Cadastro do Funcionário para Cálculo Folha
--                   Dados da Folha
--
--Data             : 18.06.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_atualiza_funcionario_dependente
@cd_funcionario int = 0
as


--select * from funcionario_dependente

select
  f.cd_funcionario,
  count(fd.cd_funcionario) as  qt_ir
into
  #FD
from
   Funcionario f
   left outer join Funcionario_Dependente fd on fd.cd_funcionario = f.cd_funcionario and
                                               ( isnull(fd.ic_ir_depedente,'N')='S' or isnull(fd.ic_deficiente,'N')='S' )

where
  f.cd_funcionario = case when @cd_funcionario = 0 then f.cd_funcionario else @cd_funcionario end 

group by
  f.cd_funcionario

select
  f.cd_funcionario,
  count(fd.cd_funcionario) as  qt_salario_familia
into
  #SF
from
   Funcionario f
   left outer join Funcionario_Dependente fd on fd.cd_funcionario = f.cd_funcionario and
                                               ( isnull(fd.ic_salario_famila_dependente,'N')='S' )

where
  f.cd_funcionario = case when @cd_funcionario = 0 then f.cd_funcionario else @cd_funcionario end 

group by
  f.cd_funcionario


--select * from #FD

--select * from funcionario_informacao

update
  funcionario_informacao
set
  qt_ir = isnull(fd.qt_ir,0)
from
  Funcionario_Informacao fi
  left outer join Funcionario f  on f.cd_funcionario = fi.cd_funcionario
  inner join #FD        fd  on fd.cd_funcionario = fi.cd_funcionario
where
  f.cd_funcionario = case when @cd_funcionario = 0 then f.cd_funcionario else @cd_funcionario end

update
  funcionario_informacao
set
  qt_salario_familia = isnull(sf.qt_salario_familia,0)
from
  Funcionario_Informacao fi
  left outer join Funcionario f  on f.cd_funcionario = fi.cd_funcionario
  inner join #SF        SF  on sf.cd_funcionario = fi.cd_funcionario
where
  f.cd_funcionario = case when @cd_funcionario = 0 then f.cd_funcionario else @cd_funcionario end


drop table #fd
drop table #sf

-- go

