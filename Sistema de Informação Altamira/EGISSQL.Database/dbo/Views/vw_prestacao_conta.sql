
--sp_helptext vw_prestacao_conta

CREATE VIEW vw_prestacao_conta
------------------------------------------------------------------------------------
--vw_prestacao_conta
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Mostra os dados da Prestação de Conta
--Data                  : 17.11.2007
--Atualização           : 25.11.2007 - complemento dos campos - Carlos Fernandes
--24.01.2008 - Ajustes nos campos para aprovação via Internet - Carlos Fernandes
--09.02.2008 - Acerto da Data de Início / Final - Carlos Fernandes
--15.02.2008 - Acerto da Observação estava cortando - Carlos Fernandes
------------------------------------------------------------------------------------
as

Select
      pc.*,
      f.cd_fornecedor, 
      isnull(f.nm_setor_funcionario,'')               as nm_setor_funcionario,
      isnull(f.cd_agencia_funcionario,'')             as cd_agencia_funcionario,
      isnull(f.cd_conta_funcionario,'')               as cd_conta_funcionario,
      f.cd_banco,
      isnull(tcc.nm_cartao_credito,'')                as nm_cartao_credito,
      isnull(b.nm_banco,'')                           as nm_banco,
      isnull(m.nm_fantasia_moeda,'')                  as nm_fantasia_moeda,
      isnull(tpc.nm_tipo_prestacao,'')                as nm_tipo_prestacao,
      isnull(mpc.nm_motivo_prestacao,'')              as nm_motivo_prestacao,
      isnull(pv.nm_projeto_viagem,'')                 as nm_projeto_viagem,
      isnull(pv.cd_identificacao_projeto,'')          as cd_identificacao_projeto,
      isnull(f.cd_chapa_funcionario,f.cd_funcionario) as cd_chapa_funcionario,
      isnull(f.nm_funcionario,'')                     as nm_funcionario,
      isnull(d.nm_departamento,'')                    as nm_departamento,
      isnull(c.nm_centro_custo,'')                    as nm_centro_custo,
      isnull(tv.nm_tipo_viagem,'Nacional')            as nm_tipo_viagem,
      isnull(av.nm_assunto_viagem,'')                 as nm_assunto_viagem,
      case when rv.dt_inicio_viagem is not null then
        rv.dt_inicio_viagem
      else
        pc.dt_inicio_prestacao
      end                                             as dt_inicio_viagem,
      case when rv.dt_fim_viagem is not null then
        rv.dt_fim_viagem
      else
        pc.dt_fim_prestacao
      end                                             as dt_fim_viagem,
      isnull(rv.nm_local_viagem,
      isnull(pc.nm_local_prestacao,''))               as nm_local_viagem,
      isnull(m.sg_moeda,'')                           as sg_moeda,

--      isnull(pc.vl_prestacao,0)                       as valor_prestacao,

      ( select sum ( isnull(vl_total_despesa,0) ) from
        prestacao_conta_composicao pcc where pcc.cd_prestacao = pc.cd_prestacao ) as valor_prestacao,

      cast( isnull(pc.ds_prestacao,'') as varchar(8000))    as ds_obs_prestacao

from
    Prestacao_Conta pc                   with (nolock) 
    left join Tipo_Prestacao_Conta   tpc with (nolock) on (pc.cd_tipo_prestacao    = tpc.cd_tipo_prestacao) 
    left join Funcionario F              with (nolock) on (f.cd_funcionario        = pc.cd_funcionario) 
    left join Departamento D             with (nolock) on (d.cd_departamento       = pc.cd_departamento) 
    left join Centro_Custo C             with (nolock) on (c.cd_centro_custo       = pc.cd_centro_custo)
    left join Tipo_Cartao_Credito tcc    with (nolock) on tcc.cd_cartao_credito    = pc.cd_cartao_credito
    left join Projeto_Viagem pv          with (nolock) on pv.cd_projeto_viagem     = pc.cd_projeto_viagem  
    left join Requisicao_Viagem rv       with (nolock) on rv.cd_requisicao_viagem  = pc.cd_requisicao_viagem 
    left join Moeda M                    with (nolock) on (m.cd_moeda              = pc.cd_moeda) 
    left join Banco b                    with (nolock) on b.cd_banco               = f.cd_banco
    left join Motivo_Prestacao_Conta mpc with (nolock) on (mpc.cd_motivo_prestacao = pc.cd_motivo_prestacao) 
    left join Assunto_Viagem av          with (nolock) on (av.cd_assunto_viagem    = pc.cd_assunto_viagem) 
    left join Tipo_Viagem tv             with (nolock) on (tv.cd_tipo_viagem       = rv.cd_tipo_viagem) 

--select * from prestacao_conta where cd_prestacao = 736
--select * from prestacao_conta_composicao where cd_prestacao = 736
