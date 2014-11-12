
--sp_helptext vw_solicitacao_adiantamento

CREATE VIEW vw_solicitacao_adiantamento
------------------------------------------------------------------------------------
--vw_solicitacao_adiantamento
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Mostra os dados da Solicitação de Adiantamento
--Data                  : 17.11.2007
--Atualização           : 25.11.2007 - complemento dos campos
--24.01.2008 - Ajustes gerais nos campos para Aprovação via Internet - Carlos Fernandes
--15.02.2008 - Acerto da Observação que está Cortando - Carlos Fernandes
----------------------------------------------------------------------------------------

as

Select
      sa.*,
      isnull(f.cd_chapa_funcionario,f.cd_funcionario)       as cd_chapa_funcionario,  
      isnull(f.nm_funcionario,'')                           as nm_funcionario,  
      isnull(d.nm_departamento,'')                          as nm_departamento,  
      isnull(cc.nm_centro_custo,'')                         as nm_centro_custo,  
      isnull(fa.nm_finalidade_adiantamento,'')              as nm_finalidade_adiantamento,  
      u.nm_usuario as nm_usuario_liberacao,  
      cast((GetDate() - dt_vencimento) as int)              as Dias,  
      isnull(av.nm_assunto_viagem,'')                       as nm_assunto_viagem,  
      isnull(m.sg_moeda,'')                                 as sg_moeda,  
      isnull(sa.vl_adiantamento,0)                          as valor_adiantamento,
      cast(isnull(sa.ds_solicitacao,'') as varchar(8000))   as ds_adiantamento
  
from
    Solicitacao_Adiantamento  SA                 with (nolock)
    left Join Funcionario  F                     with (nolock) on (sa.cd_funcionario = f.cd_funcionario) 
    left join Departamento D                     with (nolock) on (d.cd_departamento = sa.cd_departamento) 
    left join Finalidade_Adiantamento Fa         with (nolock) on (sa.cd_finalidade_adiantamento = fa.cd_finalidade_adiantamento) 
    left join EgisAdmin.dbo.Usuario U            with (nolock) on (u.cd_usuario        = sa.cd_usuario_liberacao)
    left join Solicitacao_Adiantamento_baixa sab with (nolock) on (sab.cd_solicitacao  = sa.cd_solicitacao)
    left outer join moeda m                      with (nolock) on m.cd_moeda           = sa.cd_moeda 
    left outer join Centro_Custo cc              with (nolock) on cc.cd_centro_custo   = sa.cd_centro_custo   
    left outer join Assunto_Viagem av            with (nolock) on av.cd_assunto_viagem = sa.cd_assunto_viagem
