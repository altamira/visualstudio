
create procedure pr_libera_pedido_comprador

@ic_parametro     int,
@cd_pedido_compra int,
@cd_usuario       int,
@dt_inicial       datetime,
@dt_final         datetime

AS

begin transaction

----------------------------------------------------------------
if @ic_parametro = 1 -- Listar Documentos para serem liberados.
----------------------------------------------------------------
begin

SELECT     
     pc.cd_pedido_compra, 
	   pc.dt_pedido_compra, 
	   f.nm_fantasia_fornecedor, 
     plano.nm_plano_compra,
	   pc.vl_total_pedido_ipi as 'vl_total_pedido_compra', 
	   pc.dt_nec_pedido_compra, 
     cp.nm_condicao_pagamento, 
	   pc.cd_requisicao_compra, 
	   IsNull(pc.ic_aprov_comprador_pedido,'N') as 'ic_aprov_comprador_pedido',
     '' as 'Requisitante', -- Não achei o campo.
     c.nm_comprador,
     c.nm_fantasia_comprador,
	   cast('' as varchar(60))  as NomeLiberador,
     pc.dt_alteracao_ped_compra,
     tap.nm_tipo_alteracao_pedido + '-' + pc.ds_alteracao_ped_compra as 'ds_alteracao_ped_compra',
     ( select min(dt_entrega_item_ped_compr) 
       from Pedido_Compra_Item x
       where x.cd_pedido_compra = pc.cd_pedido_compra) as dt_entrega_item_ped_compr
       
FROM       
  Pedido_Compra pc Left outer join
  Fornecedor f ON pc.cd_fornecedor = f.cd_fornecedor Left outer join
  Condicao_Pagamento cp ON pc.cd_condicao_pagamento = cp.cd_condicao_pagamento left outer join
  Comprador c on c.cd_comprador = pc.cd_comprador     left outer join
  Tipo_Alteracao_Pedido tap on tap.cd_tipo_alteracao_pedido = pc.cd_tipo_alteracao_pedido left outer join
  Plano_Compra plano on plano.cd_plano_compra = pc.cd_plano_compra


WHERE     -- pc.cd_status_pedido = 8 and
           pc.dt_cancel_ped_compra is null and
           IsNull(pc.ic_aprov_comprador_pedido,'N') = 'N' and
           ((pc.cd_pedido_compra = @cd_pedido_compra) or
	   (@cd_pedido_compra = 0 )) and 
           IsNull(pc.ic_aprov_pedido_compra, 'N') = 'N'
--	    pc.dt_pedido_compra between @dt_inicial and @dt_final))
end

-----------------------------------------------------------------------
else if @ic_parametro = 2 -- Libera o Pedido de Compra Selecionado.
-----------------------------------------------------------------------
begin


  declare @cd_tipo_aprovacao         int
  declare @cd_item_pedido_compra     int
  declare @ic_teto_liberacao         char(1)
  declare @ic_escala_tipo_aprovacao  char(1) 
  declare @vl_teto_liberacao         float
  declare @vl_inicio_escala          float
  declare @vl_final_escala           float
  declare @cd_tipo_assinatura        int

  set @cd_tipo_aprovacao = ( select cd_tipo_aprovacao 
                             from EGISADMIN.dbo.Usuario 
                              where cd_usuario = @cd_usuario )

  set @cd_item_pedido_compra = IsNull(( select max(cd_item_aprovacao_pedido)
                                 from Pedido_Compra_Aprovacao
 				 where cd_pedido_compra = @cd_pedido_compra ),0) + 1


  if @cd_tipo_aprovacao is null
    begin
      raiserror('Usuário não tem um tipo de aprovação válido cadastrado!', 16, 1)
      goto TrataErro
    end

  select
     @ic_teto_liberacao        = isnull(ic_teto_tipo_aprovacao,'N'),
     @ic_escala_tipo_aprovacao = isnull(ic_escala_tipo_aprovacao,'N') 
  from
     tipo_aprovacao
  where
     @cd_tipo_aprovacao = cd_tipo_aprovacao

  set @vl_teto_liberacao = 0.00

  if @ic_teto_liberacao = 'S'
  begin
    select 
      @cd_tipo_assinatura = isnull(cd_tipo_assinatura,0),
      @vl_teto_liberacao  = isnull(vl_pedido_compra_empresa,0)
    from 
      Parametro_Suprimento
    where 
      cd_empresa = dbo.fn_empresa()
  end

  set @vl_inicio_escala = 0.00
  set @vl_final_escala  = 0.00
  
  if @ic_escala_tipo_aprovacao = 'S'
  begin
    select 
      @vl_inicio_escala = isnull(vl_inicio_escala,0),
      @vl_final_escala  = isnull(vl_final_escala,0)
    from
      Escala_Aprovacao 
    where
     cd_tipo_aprovacao  = @cd_tipo_aprovacao and
     cd_tipo_assinatura = @cd_tipo_assinatura --Pedido de Compra
  end      

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
      @cd_item_pedido_compra
    )

    --select * from pedido_compra
    --select * from escala_aprovacao

    --Atualiza o Pedido de Compra 
    --Com a Aprovação do Comprador

    update 
      Pedido_Compra
    set 
      ic_aprov_comprador_pedido = 'S',

      ic_aprov_pedido_compra    = --Teto
                                  case when @ic_teto_liberacao = 'S' and vl_total_pedido_ipi<=@vl_teto_liberacao
                                       then 'S' 
                                       else 
                                          case when @ic_escala_tipo_aprovacao = 'S' and
                                               vl_total_pedido_ipi between @vl_inicio_escala and @vl_final_escala
                                          then 'S'
                                          else 'N'
                                          end
                                       end

    where 
      cd_pedido_compra = @cd_pedido_compra



end

--Confima Transação Caso Não Tenha Ocorrido Nenhum Erro
TrataErro:
  if @@Error = 0
    commit transaction
  else
    rollback transaction


