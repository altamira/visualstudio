
create procedure pr_libera_eletronica_pedido_compra
@ic_parametro              int      = 0,
@cd_usuario                int      = 0,
@cd_pedido_compra          int      = 0,
@dt_inicial                datetime = '',
@dt_final                  datetime = ''

as

  declare @ic_ass_eletronica_usuario char(1)
  declare @cd_tipo_aprovacao         int
  declare @vl_teto_liberacao         float
  declare @ic_teto_liberacao         char(1)
  declare @qt_ordem_tipo_aprovacao   int

--  declare @dt_inicial datetime

-------------------------------------------------------
if @ic_parametro = 1 -- Consulta os pedidos do usuário.
--------------------------------------------------------
begin

  --Verifica se o usuário é credenciado para a aprovação eletrônica
  select 
     @ic_ass_eletronica_usuario = isnull(ic_ass_eletronica_usuario,'N'),
     @cd_tipo_aprovacao         = cd_tipo_aprovacao
  from
     egisadmin.dbo.usuario with (nolock) 
  where
     cd_usuario = @cd_usuario

  --Mensagem para usuário
  if isnull(@ic_ass_eletronica_usuario,'N')='N'
    raiserror('Usuário não autorizado para Liberação Eletrônica de Pedido de Compra!', 16, 1)

  --Busca o Teto de Liberacao
  select
     @vl_teto_liberacao = isnull(vl_pedido_compra_empresa,0)
  from
     Parametro_suprimento with (nolock) 
  where
     cd_empresa = dbo.fn_empresa()

--   print 'Tipo Aprovacao:'
--   print @cd_tipo_aprovacao
-- 
--   print 'Usar Teto p/ Aprovacao:'
--   print @ic_teto_liberacao
--   print 'Valor do Teto:'
--   print @vl_teto_liberacao


  --Montagem da Tabela Auxiliar para Verificar quantas aprovacoes o Pedido de Compra 
  --possui na tabela Pedido_Compra_Aprovacao

  --select * from pedido_compra
  --select * from status_pedido

  select
     pc.cd_pedido_compra,
     count(pca.cd_pedido_compra) as 'QtdAprovacao'
  into
     #Qtd_Pedido_Aprovado
  from
     Pedido_Compra pc, Pedido_Compra_Aprovacao pca
 
  where
     pc.cd_pedido_compra = pca.cd_pedido_compra    and
     isnull(pc.ic_aprov_pedido_compra,'N') = 'N'   and
     pc.cd_status_pedido = 8                       --Pedido em Aberto
  group by
     pc.cd_pedido_compra

  --Verifica se Existe a consistência do Teto de Liberacao
  --Busca a hierarquia para o Tipo de Aprovação  
  set @ic_teto_liberacao = 'N'

  select
     @ic_teto_liberacao       = ic_teto_tipo_aprovacao,
     @qt_ordem_tipo_aprovacao = qt_ordem_tipo_aprovacao 
  from
     tipo_aprovacao with (nolock) 
  where
     @cd_tipo_aprovacao = cd_tipo_aprovacao

  -----------------------------------------------------------------------------
  if IsNull(@ic_teto_liberacao,'N') = 'N'  -- ABAIXO DO TETO
  -----------------------------------------------------------------------------
  begin
  
    select     
      distinct
      pc.cd_pedido_compra, 
      pc.dt_pedido_compra, 
      f.nm_fantasia_fornecedor, 
      IsNull(pc.vl_total_pedido_ipi, pc.vl_total_pedido_compra) as vl_total_pedido_compra, 
      pc.dt_nec_pedido_compra, 
      plano.nm_plano_compra,
      cp.nm_condicao_pagamento, 
      (select top 1 pci.cd_requisicao_compra 
       from Pedido_Compra_Item pci
       where pci.cd_pedido_compra = pc.cd_pedido_compra ) 	as 'cd_requisicao_compra', 
      'N' 							as 'ic_aprov_comprador_pedido',
      u.nm_fantasia_usuario 					as 'Requisitante',
      d.nm_departamento,
      c.nm_fantasia_comprador,
      cast('' as varchar(60)) 					as 'NomeLiberador',
      pc.dt_alteracao_ped_compra,
      IsNull(tap.nm_tipo_alteracao_pedido + '-','') + IsNull(pc.ds_alteracao_ped_compra,'') as 'ds_alteracao_ped_compra',
     ( select min(dt_entrega_item_ped_compr) 
       from Pedido_Compra_Item x with (nolock)
       where x.cd_pedido_compra = pc.cd_pedido_compra) as dt_entrega_item_ped_compr,
     cc.nm_centro_custo

    from
      Pedido_Compra pc                            with (nolock) 
      left outer join Departamento_Aprovacao da   with (nolock) on pc.cd_departamento       = da.cd_departamento 
      left outer join Fornecedor f                with (nolock) on pc.cd_fornecedor         = f.cd_fornecedor 
      left outer join Condicao_Pagamento cp       with (nolock) on pc.cd_condicao_pagamento = cp.cd_condicao_pagamento 
      left outer join Pedido_Compra_Aprovacao pca with (nolock) on pca.cd_pedido_compra         = pc.cd_pedido_compra and 
                                                                   pca.cd_usuario               = @cd_usuario 
      left outer join Departamento d              with (nolock) on d.cd_departamento            = pc.cd_departamento
      left outer join Centro_Custo cc             with (nolock) on cc.cd_centro_custo           = pc.cd_centro_custo
      left outer join Comprador c                 with (nolock) on c.cd_comprador               = pc.cd_comprador 
      inner join EGISADMIN.dbo.Usuario u          with (nolock) on u.cd_usuario                 = pc.cd_usuario 
      left outer join Tipo_Alteracao_Pedido tap   with (nolock) on tap.cd_tipo_alteracao_pedido = pc.cd_tipo_alteracao_pedido 
      left outer join Plano_Compra plano          with (nolock) on plano.cd_plano_compra = pc.cd_plano_compra 
      left outer join #Qtd_Pedido_Aprovado qpa                  on  pc.cd_pedido_compra      = qpa.cd_pedido_compra 
    where
       isnull(pc.ic_aprov_comprador_pedido,'N') = 'S'           and  --Aprovacao pelo Comprador
       da.cd_tipo_aprovacao = @cd_tipo_aprovacao    and 
       pc.dt_cancel_ped_compra is null              and
       ((pc.cd_pedido_compra = @cd_pedido_compra)   or
        (@cd_pedido_compra = 0))                    and
       isNull(pc.ic_aprov_pedido_compra, 'N') = 'N' and   -- O Mais essencial, não pode estar aprovado.
       @qt_ordem_tipo_aprovacao = qpa.QtdAprovacao + 1
       and pc.cd_status_pedido = 8                        -- Em aberto

    Order by
       pc.dt_pedido_compra 

  end 

  -----------------------------------------------------------------------------
  else if IsNull(@ic_teto_liberacao,'N') ='S'  -- ACIMA DO TETO
  -----------------------------------------------------------------------------
  begin
  
    select 
      distinct
      pc.cd_pedido_compra, 
      pc.dt_pedido_compra, 
      f.nm_fantasia_fornecedor, 
      IsNull(pc.vl_total_pedido_ipi, pc.vl_total_pedido_compra) as vl_total_pedido_compra, 
      pc.dt_nec_pedido_compra, 
      cp.nm_condicao_pagamento, 
      plano.nm_plano_compra,
      (select top 1 pci.cd_requisicao_compra 
       from Pedido_Compra_Item pci
       where pci.cd_pedido_compra = pc.cd_pedido_compra ) 	as 'cd_requisicao_compra', 
      'N' 							as 'ic_aprov_comprador_pedido',
      d.nm_departamento,
      c.nm_fantasia_comprador,
      cast('' as varchar(60)) 					as 'NomeLiberador',
      u.nm_fantasia_usuario as 'Requisitante',
      pc.dt_alteracao_ped_compra,
      IsNull(tap.nm_tipo_alteracao_pedido + '-','') + IsNull(pc.ds_alteracao_ped_compra,'') as 'ds_alteracao_ped_compra',
     ( select min(dt_entrega_item_ped_compr) 
       from Pedido_Compra_Item x with (nolock) 
       where x.cd_pedido_compra = pc.cd_pedido_compra) as dt_entrega_item_ped_compr,
      cc.nm_centro_custo

    from
      Pedido_Compra pc with (nolock) left outer join
      Departamento_Aprovacao da on pc.cd_departamento = da.cd_departamento left outer join
      Fornecedor f on pc.cd_fornecedor = f.cd_fornecedor left outer join
      Condicao_Pagamento cp on pc.cd_condicao_pagamento = cp.cd_condicao_pagamento left outer join
      Pedido_Compra_Aprovacao pca on pca.cd_pedido_compra = pc.cd_pedido_compra and 
                                     pca.cd_usuario = @cd_usuario left outer join
      Departamento d on d.cd_departamento = pc.cd_departamento left outer join
      Centro_Custo cc on cc.cd_centro_custo = pc.cd_centro_custo left outer join
      Comprador c on c.cd_comprador = pc.cd_comprador inner join
      EGISADMIN.dbo.Usuario u on u.cd_usuario = pc.cd_usuario left outer join
      Tipo_Alteracao_Pedido tap on tap.cd_tipo_alteracao_pedido = pc.cd_tipo_alteracao_pedido left outer join
      Plano_Compra plano          on plano.cd_plano_compra = pc.cd_plano_compra left outer join
      #Qtd_Pedido_Aprovado qpa on pc.cd_pedido_compra = qpa.cd_pedido_compra
    where
      isnull(pc.ic_aprov_comprador_pedido,'N') = 'S'          and  --Aprovacao pelo Comprador
      da.cd_tipo_aprovacao = @cd_tipo_aprovacao   and 
      pc.dt_cancel_ped_compra is null             and
      IsNull(pc.vl_total_pedido_ipi, pc.vl_total_pedido_compra) > @vl_teto_liberacao and
      ((pc.cd_pedido_compra = @cd_pedido_compra)  or (@cd_pedido_compra = 0)) and
      isNull(pc.ic_aprov_pedido_compra, 'N') = 'N' and   -- O Mais essencial, não pode estar aprovado.
      @qt_ordem_tipo_aprovacao = qpa.QtdAprovacao + 1
      and pc.cd_status_pedido = 8                        -- Em aberto


    order by
      pc.dt_pedido_compra 
  end 

end

-------------------------------------------------------------------------
else if @ic_parametro = 2 -- Atualiza as tabelas de Pedido de Compra.
-------------------------------------------------------------------------
begin
  declare @cd_item_pedido_compra int

  set @cd_item_pedido_compra = ( select max(cd_item_aprovacao_pedido)+ 1
 				 from Pedido_Compra_Aprovacao
 				 where cd_pedido_compra = @cd_pedido_compra ) 


  set @cd_tipo_aprovacao = ( select cd_tipo_aprovacao 
                             from EGISADMIN.dbo.Usuario 
                              where cd_usuario = @cd_usuario )

  if @cd_tipo_aprovacao is null
    raiserror('Usuário não tem um tipo de aprovação válido cadastrado!', 16, 1)

  insert into Pedido_Compra_Aprovacao ( 
    cd_pedido_compra,
    cd_tipo_aprovacao,
    cd_usuario_aprovacao,
    dt_usuario_aprovacao, 
    cd_usuario,
    dt_usuario,
    cd_item_aprovacao_pedido )
  values 
    ( @cd_pedido_compra,
      @cd_tipo_aprovacao,
      @cd_usuario,
      GetDate(),
      @cd_usuario,
      GetDate(),
      IsNull(@cd_item_pedido_compra,1)
    )


end



