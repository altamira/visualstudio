
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_prestacao_contas
-------------------------------------------------------------------------------
--pr_consulta_prestacao_contas
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Prestação de Contas
--Data             : 11.04.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_prestacao_contas
@nm_obs_item_despesa varchar(40) = '',
@cd_cliente          int         = 0,
@nm_cliente_despesas varchar(40) = '',
@dt_inicial          datetime    = '',
@dt_final            datetime    = ''

as

--select * from prestacao_conta_composicao

Select
      pc.*,
      tpc.nm_tipo_prestacao,
      f.nm_funcionario,
      f.nm_email_funcionario,
      d.nm_departamento,
      c.nm_centro_custo,
    tcc.nm_cartao_credito,
    pc.vl_prestacao * case when pc.vl_prestacao<0 then -1 else 1 end as vl_prestacao_corrigido,

    case when pc.ic_tipo_deposito_prestacao='F' 
    then
      pc.vl_prestacao
    else
     0.00
    end                                as vl_pagamento_funcionario,

   case when pc.ic_tipo_deposito_prestacao='E'
   then
     pc.vl_prestacao * -1
   else
     0.00
   end                                as vl_pagamento_empresa,
   av.nm_assunto_viagem,
   nm_status_aprovacao = ( select top 1 case when ic_aprovado='S' then 'Aprovada'
                                                else
                                                   case when ic_aprovado='N' then 'Reprovada' else 'Aguardando Aprovação' end
                                                end  
                                                from prestacao_conta_aprovacao pca where pca.cd_prestacao = pc.cd_prestacao ),
   up.nm_fantasia_usuario,
   m.sg_moeda

from
    Prestacao_Conta pc                       with (nolock) left join
    Tipo_Prestacao_Conta   tpc               with (nolock) On (pc.cd_tipo_prestacao = tpc.cd_tipo_prestacao) left join
    Funcionario F                            with (nolock) On (f.cd_funcionario = pc.cd_funcionario) left join
    Departamento D                           with (nolock) On (d.cd_departamento = pc.cd_departamento) left join
    Centro_Custo C                           with (nolock) On (c.cd_centro_custo = pc.cd_centro_custo)
    left outer join Tipo_Cartao_Credito tcc  with (nolock) on tcc.cd_cartao_credito = pc.cd_cartao_credito
    left outer join Assunto_Viagem av        with (nolock) on av.cd_assunto_viagem = pc.cd_assunto_viagem
    left outer join egisadmin.dbo.Usuario up with (nolock) on up.cd_usuario = pc.cd_usuario_prestacao
    left outer join Moeda m                  with (nolock) on m.cd_moeda = pc.cd_moeda
where

   (pc.dt_prestacao between @dt_inicial and @dt_final) 



order by pc.dt_prestacao desc, pc.cd_prestacao desc


