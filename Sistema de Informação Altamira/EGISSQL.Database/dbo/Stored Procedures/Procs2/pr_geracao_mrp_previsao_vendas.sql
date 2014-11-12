
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_mrp_previsao_vendas
-------------------------------------------------------------------------------
--pr_geracao_mrp_previsao_vendas
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Geração do MRP com a Previsão de Vendas
--Data             : 11.06.2010
--Alteração        : 26.08.2010 - Ajustes Diversos - Carlos Fernandes
--
-- 03.09.2010 - Novos Flags e controle - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_geracao_mrp_previsao_vendas
@ic_parametro int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@cd_usuario   int      = 0,
@cd_plano     int      = 0

as

--plano_mrp_composicao

declare @cd_plano_mrp    int
declare @Tabela	         varchar(80)
declare @dt_hoje         datetime
declare @cd_departamento int
declare @cd_fase_produto int

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

--Fase do Produto

select
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  parametro_comercial pc with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

--Geração

if @ic_parametro = 0
begin

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Plano_MRP' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_plano_mrp', @codigo = @cd_plano_mrp output
	
  while exists(Select top 1 'x' from Plano_MRP where cd_plano_mrp = @cd_plano_mrp)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_plano_mrp', @codigo = @cd_plano_mrp output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_plano_mrp, 'D'
  end

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_plano_mrp, 'D'


--Departamento

select
  @cd_departamento = isnull(cd_departamento,null)
from
  egisadmin.dbo.usuario
where
  cd_usuario = @cd_usuario

--select * from origem_plano_mrp
--select * from status_plano_mrp

select
  @cd_plano_mrp         as cd_plano_mrp,
  'Previsão de Vendas'  as nm_plano_mrp,
  @dt_hoje              as dt_plano_mrp,
  null                  as qt_plano_mrp,
  (select top 1
    op.cd_origem_plano_mrp
  from
    origem_plano_mrp op with (nolock) 
  where
    isnull(ic_previsao_origem,'N') = 'S'
  )                     as cd_origem_plano_mrp,
  1                     as cd_status_plano_mrp,
  @cd_usuario           as cd_usuario,
  getdate()             as dt_usuario,
  cast('' as varchar)   as nm_obs_plano_mrp,
  @cd_departamento      as cd_departamento,
  'N'                   as ic_gerado_plano_mrp,
  'N'                   as ic_processo_plano,
  'N'                   as ic_req_compra_plano,
  'N'                   as ic_req_interna_plano


into
  #Plano_MRP

insert into
  Plano_MRP
select
  * 
from
  #Plano_MRP

drop table #Plano_MRP

---------------------------------------------------------------------------------------------------
select
  @cd_plano_mrp              as cd_plano_mrp,
  identity(int,1,1)          as cd_item_plano_mrp,
  pvi.cd_produto,
  case when isnull(p.cd_fase_produto_baixa,0)=0 
  then
    @cd_fase_produto
  else
    p.cd_fase_produto_baixa
  end                        as cd_fase_produto,

  --pvi.qt_saldo_pedido_venda  as qt_plano_mrp,

  case when month(pvi.dt_inicio_previsao_venda) = 1 then qt_jan_previsao
  else 
    case when month(pvi.dt_inicio_previsao_venda) = 2 then qt_fev_previsao
      else
        case when month(pvi.dt_inicio_previsao_venda) = 3 then qt_mar_previsao
          else
            case when month(pvi.dt_inicio_previsao_venda) = 4 then qt_abr_previsao
              else
                case when month(pvi.dt_inicio_previsao_venda) = 5 then qt_mai_previsao
                   else
                     case when month(pvi.dt_inicio_previsao_venda) = 6 then qt_jun_previsao
                        else
                          case when month(pvi.dt_inicio_previsao_venda) = 7 then qt_jul_previsao
                            else
                               case when month(pvi.dt_inicio_previsao_venda) = 8 then qt_ago_previsao
                                 else
                                    case when month(pvi.dt_inicio_previsao_venda) = 9 then qt_set_previsao
                                      else
                                        0.00
                                      end
--                                          case when month(pvi.dt_inicio_previsao_venda) = 10 then qt_out_previsao
--                                            else
--                                               case when month(pvi.dt_inicio_previsao_venda) = 11 then qt_nov_previsao
--                                                else
--                                                  case when month(pvi.dt_inicio_previsao_venda) = 12 then qt_dez_previsao
--                                                    else 0.00 
--                                                  end
--                                              end    
--                                          end
--                                     end
                                end
                          end
                     end
                end
            end
        end
    end

  end                        as qt_plano_mrp,
  
  @cd_usuario                as cd_usuario,
  getdate()                  as dt_usuario,
  null                       as cd_pedido_venda,
  null                       as cd_item_pedido_venda,
  null                       as cd_requisicao_compra,
  null                       as cd_requisicao_interna,
  null                       as cd_processo,
  pvi.cd_previsao_venda      as cd_previsao_venda


into
  #plano_mrp_composicao

from
  --select * from previsao_venda
  --select * from previsao_venda_composicao
  previsao_venda pvi
  inner join previsao_venda_composicao pv with (nolock) on pv.cd_previsao_venda = pvi.cd_previsao_venda
  inner join produto p                    with (nolock) on p.cd_produto         = pvi.cd_produto

where
  pvi.dt_inicio_previsao_venda = @dt_inicial and
  pvi.dt_final_previsao_venda  = @dt_final   and
  pvi.cd_previsao_venda not in ( select cd_previsao_venda
                                   from
                                     plano_mrp_composicao prc with (nolock) 
                                   where
                                     prc.cd_previsao_venda      = pvi.cd_previsao_venda )

--   and pvi.cd_pedido_venda = 10461
--   and pvi.cd_item_pedido_venda = 1

--select * from pedido_venda_item where cd_pedido_venda = 900341

order by
  pvi.cd_produto


insert into
  plano_mrp_composicao
select
  *
from
  #plano_mrp_composicao


declare @qt_plano_mrp int

set @qt_plano_mrp = 0

select
  @qt_plano_mrp = isnull(count(cd_produto),0)
from
  #plano_mrp_composicao
group by
  cd_produto  

--Atualiza a Quantidade de Produtos para Produção

update
  plano_mrp
set
  qt_plano_mrp = @qt_plano_mrp
from
  plano_mrp
where
  cd_plano_mrp = @cd_plano_mrp 

--Verifica se houve pedido para processar

if @qt_plano_mrp=0 
begin
  delete from plano_mrp 
  where
  cd_plano_mrp = @cd_plano_mrp 

end
else
  --Gera a Lista de Necessidade-------------------------------------------------------------------

  exec pr_mrp_calculo_geral 9,@dt_inicial,@dt_final,'S',@cd_plano_mrp,@cd_usuario

------------------------------------------------------------------------------

--select * from tipo_produto_projeto


end

------------------------------------------------------------------------------
--Deleção
------------------------------------------------------------------------------

if @ic_parametro = 1 and @cd_plano>0 
begin

  delete from plano_mrp_composicao where cd_plano_mrp = @cd_plano
  delete from plano_mrp            where cd_plano_mrp = @cd_plano
 

end
  

--select * from pedido_venda_item 

--select cd_tipo_produto_projeto,* from produto_processo
--select * from tipo_produto_projeto

