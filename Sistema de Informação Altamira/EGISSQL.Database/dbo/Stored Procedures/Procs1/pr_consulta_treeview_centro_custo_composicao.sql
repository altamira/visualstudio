
-------------------------------------------------------------------------------
--pr_consulta_treeview_centro_custo_composicao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 20/01/2002
--Atualizado       : 16/06/2005 - Revisão da Stored Procedure
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_treeview_centro_custo_composicao
as

  --Criando tabela para inserção dos pais
  Select
    0 cd_pai,
    cd_centro_custo cd_filho,
    nm_centro_custo,
    cd_centro_custo,
    0 cd_item_centro_custo,
    LTrim(RTrim(Str(cd_centro_custo))) nm_mascara,
    0 cd_departamento,
    nm_centro_custo nm_departamento,
    0 pc_centro_custo 
  Into 
    #Tab1
  From
    Centro_custo

  --criando tabela filho com o código zerado
  select 
    c.cd_centro_custo as cd_pai,
    0 as cd_filho,
--     cc.cd_item_centro_custo + 1 as cd_filho, -- Código Filho
    case when isnull(cc.nm_item_centro_custo,'')<>'' then cc.nm_item_centro_custo else c.nm_centro_custo end as nm_centro_custo,
    c.cd_centro_custo,
    cc.cd_item_centro_custo,
    RTrim(LTrim(Str(c.cd_centro_custo))) + '.' + RTrim(LTrim(Str(cc.cd_item_centro_custo))) nm_mascara,
    d.cd_departamento,
    d.nm_departamento,  cc.pc_centro_custo
  Into
    #Tab2
  from 
    Centro_custo c
      Inner Join
    Centro_custo_Composicao cc
      on c.cd_centro_custo = cc.cd_centro_custo
      Inner Join 
    Departamento d
      on cc.cd_departamento = d.cd_departamento

 
  --Juntando os valores de pai com os valores dos filhos zerados
  Insert Into #Tab1
  Select
    cd_pai,
    cd_filho,
    nm_centro_custo,
    cd_centro_custo,
    cd_item_centro_custo,
    nm_mascara,
    cd_departamento,
    nm_centro_custo nm_departamento,
    IsNull(pc_centro_custo,0) as pc_centro_custo
  From
    #Tab2

-----------------------------------------------------------------
--Rotina para gerar o campo do filho
-----------------------------------------------------------------
  Select 
    * 
  Into
    #Tab3
  From
    #tab1
  Where
    cd_pai <> 0
  
  Declare @identity int
  Declare @mascara varchar(20)

  Select @identity = max(cd_filho) From #Tab1

  While Exists (Select top 1 'X' from #Tab3)
  Begin

    Set @identity = @identity + 1

    Select top 1 @mascara = nm_mascara From #Tab3

    update #Tab1
    set cd_filho = @identity
    where nm_mascara = @mascara

    delete #Tab3
    where nm_mascara = @mascara

  End
-----------------------------------------------------------------
--Término da rotina
-----------------------------------------------------------------


  Select 
    cd_pai,
    cd_filho,
    nm_centro_custo,
    cd_centro_custo,
    cd_item_centro_custo,
    nm_mascara,
    cd_departamento,
    nm_departamento,
    pc_centro_custo
  from 
    #Tab1


