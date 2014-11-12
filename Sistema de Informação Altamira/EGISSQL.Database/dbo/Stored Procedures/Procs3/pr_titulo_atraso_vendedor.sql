
CREATE PROCEDURE pr_titulo_atraso_vendedor
  @cd_vendedor          int = 0,
  @qt_dia_atraso        int = 0

AS

declare @dt_hoje             datetime 
declare @cd_tipo_vendedor    int
declare @cd_vendedor_interno int 

set @dt_hoje             = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
set @cd_tipo_vendedor    = 2 --Externo
set @cd_vendedor_interno = @cd_vendedor

select
  @cd_tipo_vendedor = isnull(cd_tipo_vendedor,2)
from
  vendedor with (nolock) 
where
  cd_vendedor = @cd_vendedor

select  
  dr.cd_documento_receber,
         v.nm_fantasia_vendedor,
         c.nm_fantasia_cliente,
         dr.cd_identificacao,
         dr.dt_emissao_documento,
         dr.dt_vencimento_documento,
         dr.vl_documento_receber,

         --dr.cd_nota_saida,
         case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
           ns.cd_identificacao_nota_saida
         else
           ns.cd_nota_saida                  
         end                                   as 'cd_nota_saida',

         dr.cd_pedido_venda,
         dr.vl_saldo_documento,
         cast( GetDate() - dr.dt_vencimento_documento as Integer) as 'QtAtraso',
         case when dr.dt_vencimento_documento<@dt_hoje then
            'Vencido'
         else
            'A Vencer'
         end                                                      as 'Observacao',

--         pv.cd_vendedor_interno,

-- 28.01.2010

         case when isnull(pv.cd_vendedor_interno,0)=0 then
           c.cd_vendedor_interno
         else     
           pv.cd_vendedor_interno
         end                                                      as 'cd_vendedor_interno',

         vi.nm_fantasia_vendedor                                  as 'Vendedor_Interno',

         cast(isnull((select
                  top 1
                  cast(drh.ds_historico_documento as varchar(500))
                from
                  documento_receber_historico drh with (nolock) 
                where
                  drh.cd_documento_receber = dr.cd_documento_receber
                order by
                  dt_historico_documento desc ),'') as varchar(500)) as 'nm_historico__documento',

   vw.nm_pais,
   vw.nm_cidade,
   vw.sg_estado

into
  #Titulo_Vendedor

--select * from pedido_venda
--select * from documento_receber_historico

from
   Documento_Receber dr            with (nolock) 
   left outer join Vendedor v      with (nolock) on v.cd_vendedor      = dr.cd_vendedor 
   left outer join Cliente c       with (nolock) on c.cd_cliente       = dr.cd_cliente
   left outer join Pedido_Venda pv with (nolock) on pv.cd_pedido_venda = dr.cd_pedido_venda
--   left outer join Vendedor vi     with (nolock) on vi.cd_vendedor     =  pv.cd_vendedor_interno
   left outer join Vendedor vi     with (nolock) on vi.cd_vendedor     =  
                                                    case when isnull(pv.cd_vendedor_interno,0)=0 then
                                                       c.cd_vendedor_interno
                                                    else
                                                       pv.cd_vendedor_interno
                                                    end
   left outer join vw_destinatario vw on vw.cd_tipo_destinatario = dr.cd_tipo_destinatario and
                                         vw.cd_destinatario      = dr.cd_cliente

   left outer join Nota_Saida ns      on ns.cd_nota_saida        = dr.cd_nota_saida

--select * from vw_destinatario

where 

  dr.cd_vendedor = case when @cd_vendedor = 0 or @cd_tipo_vendedor <> 2 
                   then dr.cd_vendedor 
                   else @cd_vendedor end and

  dr.dt_cancelamento_documento is null                          and
  dr.dt_devolucao_documento    is null                          and
  isnull(dr.vl_saldo_documento,0) > 0

Order by
   dr.cd_documento_receber Desc, dr.dt_emissao_documento


----------------------------------------------------------------------------------------
--Verifica o Tipo do Vendedor
----------------------------------------------------------------------------------------
if @cd_tipo_vendedor = 1 and @cd_vendedor_interno <> 0 
begin
  delete from #Titulo_Vendedor 
  where
   cd_vendedor_interno <> @cd_vendedor_interno    
end

if @qt_dia_atraso <> 0
begin
  select
    *
  from
    #Titulo_Vendedor
  where
--    cd_vendedor = case when @cd_vendedor = 0 then dr.cd_vendedor else @cd_vendedor end 
--    and
   dt_vencimento_documento < ( @dt_hoje - @qt_dia_atraso )    

  Order by
    cd_documento_receber Desc, dt_emissao_documento

end

else
  select
    *
  from
    #Titulo_Vendedor
--   where
--   cd_vendedor = case when @cd_vendedor = 0 then dr.cd_vendedor else @cd_vendedor end 

  Order by
    cd_documento_receber Desc, dt_emissao_documento


