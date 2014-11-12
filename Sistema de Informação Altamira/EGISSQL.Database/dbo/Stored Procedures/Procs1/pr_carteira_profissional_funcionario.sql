
-------------------------------------------------------------------------------
--pr_carteira_profissional_funcionario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 06/10/2005
--Atualizado       : 06/10/2005
--------------------------------------------------------------------------------------------------
create procedure pr_carteira_profissional_funcionario
@ic_parametro int = 0,
@dt_inicial   datetime,
@dt_final     datetime
as

 select
   f.cd_funcionario,
   f.cd_registro_funcionario,
   f.nm_funcionario,
   d.nm_departamento,
   fi.dt_alteracao_cart_prof,
   fi.ic_atualizacao_cart_prof,
   case when
        fi.ic_atualizacao_cart_prof = 'F'        then 'Férias' 
        else
          case when fi.ic_atualizacao_cart_prof = 'R' then 'Rescisão'        
            else
              case when fi.ic_atualizacao_cart_prof = 'S' then 'Reajuste Salário' 
                 else
                  case when fi.ic_atualizacao_cart_prof = 'M' then 'Mudança Cargo' 
                    else
                     case when fi.ic_atualizacao_cart_prof = 'O' then 'Outros' else '' end
                    end
                  end
            end               
        end as Motivo,
   cast( getdate() - fi.dt_alteracao_cart_prof as int ) as Dias
  into #AuxFunc
  from
    Funcionario f
    inner join funcionario_informacao fi on fi.cd_funcionario = f.cd_funcionario
    left outer join Departamento d       on d.cd_departamento = f.cd_departamento
  where
    isnull(ic_atualizacao_cart_prof,'N')<>'N'

if @ic_parametro=0 
begin
   select * from #AuxFunc
end
else
begin
  if @ic_parametro=1
  begin
    declare @cd_funcionario int
    while exists ( select top 1 cd_funcionario from #AuxFunc )
    begin
      select top 1 @cd_funcionario = cd_funcionario
      from 
        #AuxFunc
      
      --Atualiza o Cadastro de Funcionários
      update
        Funcionario_Informacao
      set
        ic_atualizacao_cart_prof = 'N',
        dt_alteracao_cart_prof   = null 

      delete #AuxFunc where cd_funcionario = @cd_funcionario
              
    end
  end
end

