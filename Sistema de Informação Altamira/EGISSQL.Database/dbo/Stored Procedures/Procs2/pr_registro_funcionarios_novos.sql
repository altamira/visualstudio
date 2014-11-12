
create procedure pr_registro_funcionarios_novos
@dt_inicial datetime,
@dt_final   datetime
as

declare @qt_funcionario int

set @qt_funcionario = 0

select  
  @qt_funcionario = count(cd_funcionario)
from 
  funcionario
where
  dt_admissao_funcionario between @dt_inicial and @dt_final  

--select * from funcionario


--Resultado

select 
  @qt_funcionario as 'QtdRegistroFuncionario'



