
-------------------------------------------------------------------------------
--sp_helptext pr_calculo_desconto_total_proposta
-------------------------------------------------------------------------------
--pr_calculo_desconto_total_consulta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Cálculo Geral do Desconto da Proposta/Item
--Data             : 27.12.2010 
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_calculo_desconto_total_proposta
@cd_consulta     int   = 0,
@vl_desconto     float = 0,
@pc_desconto     float = 0

as

-------------------------------------------------------------------------------------
--Cálculo Pedido de Venda
-------------------------------------------------------------------------------------

if @cd_consulta > 0 and ( @vl_desconto > 0 or @pc_desconto > 0 )
begin

  declare @vl_total_consulta float
  declare @i_arr           int

  select 
    @i_arr = isnull(m.qt_num_digitos,4)
  from
    Moeda m
  where m.cd_moeda = 1

  --select * from moeda 
    
  set @vl_total_consulta = 0

  select
    @vl_total_consulta = isnull(vl_total_consulta,0.00)
  from
    Consulta pv with (nolock) 

  where
    pv.cd_consulta = @cd_consulta

  --select * from consulta

  --Calculo do Valor do desconto--------------------------------------------------------
  if @pc_desconto > 0
  begin
    set @vl_desconto = 0
    set @vl_desconto = (@vl_total_consulta * @pc_desconto/100) 
  end

--  select @vl_total_consulta,@vl_desconto,(@vl_total_consulta-@vl_desconto)

--select * from consulta

  --Montagem da Tabela de Itens com o Rateio----------------------------------------------

  select
    pvi.cd_consulta,
    pvi.cd_item_consulta,
    pvi.qt_item_consulta,
    pc_item_consulta = round(((pvi.qt_item_consulta*pvi.vl_unitario_item_consulta)/pv.vl_total_consulta),4)
  into
    #ItemConsultaDesconto

  from
    consulta_itens       pvi with (nolock) 
    inner join consulta pv  on pv.cd_consulta = pvi.cd_consulta

  where
    pv.cd_consulta     = @cd_consulta 
    and pv.cd_consulta = pvi.cd_consulta
    and isnull(pv.vl_total_consulta,0)>0
  
--  select * from   #ItemConsultaDesconto

--select * from consulta_itens


  --Atualiza os novos valores----------------------------------------

  update
    consulta_itens
  set
    vl_unitario_item_consulta =   round(((@vl_total_consulta - @vl_desconto) * d.pc_item_consulta ) / i.qt_item_consulta,@i_arr),
    pc_desconto_item_consulta =   round((((vl_lista_item_consulta - ( ((@vl_total_consulta - @vl_desconto) * d.pc_item_consulta ) / i.qt_item_consulta ) ) * 100) / vl_lista_item_consulta ),4),   
    ic_desconto_item_consulta =   case when isnull(pc_desconto_item_consulta,0)>0 then 'S' else 'N' end

  from
    consulta_itens i 
    inner join #ItemConsultaDesconto d on d.cd_consulta      = i.cd_consulta      and
                                          d.cd_item_consulta = i.cd_item_consulta 
  where
    i.cd_consulta = @cd_consulta

  --select * from consulta_item


--  select * from consulta_itens where cd_consulta = @cd_consulta 

end

  

