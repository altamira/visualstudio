
CREATE PROCEDURE pr_geracao_previa_faturamento_programacao

@cd_usuario            int = 0

as

--select * from previa_faturamento

declare @cd_previa_faturamento int
declare @dt_previa_faturamento datetime

set @cd_previa_faturamento = 0


declare @Tabela	     varchar(50)

set @Tabela      = cast(DB_NAME()+'.dbo.Previa_Faturamento' as varchar(50))

while @cd_previa_faturamento = 0
begin

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_previa_faturamento', @codigo = @cd_previa_faturamento output


  --Verifica se Existe a Prévia

  if not exists(select cd_previa_faturamento from previa_faturamento where @cd_previa_faturamento=cd_previa_faturamento )
  begin

   set @dt_previa_faturamento = cast(convert(int,getdate()-1,103) as datetime)

   --Montagem da Tabela Temporária

   select
     @cd_previa_faturamento       as cd_previa_faturamento,
     @dt_previa_faturamento       as dt_previa_faturamento,
     null                         as qt_pedido_previa_faturam,
     null                         as vl_pedido_previa_faturam,
     cast('' as varchar)          as ds_pedido_previa_faturam,
     @cd_usuario                  as cd_usuario,
     getdate()                    as dt_usuario,
     null                         as vl_previa_faturamento,
     'Romaneio '                  as nm_previa_faturamento,
     'N'                          as ic_fatura_previa_faturam,
     null                         as cd_previa_anterior_sap,
     null                         as qt_pedido_previa_faturame,
     null                         as vl_pedido_previa_faturame,
     null                         as ic_previa_imediato

   into #Previa_Faturamento

   --select * from #Previa_Faturamento

   --Cria uma Tabela Temporária - Itens da Prévia Faturamento
   --select * from previa_faturamento_composicao
   --select * from programacao_entrega

   select
     @cd_previa_faturamento                as cd_previa_faturamento,
     identity(int,1,1)                     as cd_item_previa_faturam,
     per.cd_pedido_venda,
     per.cd_item_pedido_venda,
     isnull(per.qt_remessa_produto,0)      as qt_previa_faturamento,
     'N'                                   as ic_etiqueta_emb_previa,
     'Programação Entrega : '+cast(pe.cd_programacao_entrega as varchar) as nm_obs_item_previa_fatura,
     @cd_usuario                           as cd_usuario,
     getdate()                             as dt_usuario,
     isnull(pvi.vl_unitario_item_pedido,0) as vl_item_previa_faturam,
     null                                  as qt_volume_previa_faturam,
     isnull(pvi.qt_bruto_item_pedido,0)    as qt_bruto_previa_faturam,
     isnull(pvi.qt_liquido_item_pedido,0)  as qt_liquido_previa_faturam,
     null                                  as cd_pallete_previa_faturam,
     null                                  as ic_total_previa_faturam,
     'N'                                   as ic_fatura_previa_faturam,
     pe.cd_programacao_entrega   
     
   into #Previa_Faturamento_Composicao
   from
     Programacao_Entrega pe                     with (nolock)
     inner join Programacao_Entrega_Remessa per with (nolock) on per.cd_programacao_entrega = pe.cd_programacao_entrega
     left  join Pedido_Venda_item           pvi with (nolock) on pvi.cd_pedido_venda        = per.cd_pedido_venda and
                                                                 pvi.cd_item_pedido_venda   = per.cd_item_pedido_venda
     
   where
     isnull(per.cd_previa_faturamento,0)   = 0 and
     isnull(pe.ic_selecao_programacao,'N') = 'S'

    --select * from pedido_venda_item

    --Geração 

    insert into
      Previa_Faturamento
    select
      *
    from
      #Previa_Faturamento

    insert into
      previa_faturamento_composicao
    select
      *
    from
      #previa_faturamento_composicao

    --Atualiza a Programação Selecionada com o Número da Prévia de Faturamento

    update
      programacao_entrega
    set
      cd_previa_faturamento = i.cd_previa_faturamento
    from
      programacao_entrega pe
      inner join previa_faturamento_composicao i on i.cd_programacao_entrega = pe.cd_programacao_entrega
    where
      isnull(pe.ic_selecao_programacao,'N') = 'S' and
      isnull(pe.cd_previa_faturamento,0) = 0

    update
      programacao_entrega_remessa
    set
      cd_previa_faturamento = i.cd_previa_faturamento
    from
      programacao_entrega_remessa per
      inner join programacao_entrega pe          on pe.cd_programacao_entrega = per.cd_programacao_entrega
      inner join previa_faturamento_composicao i on i.cd_programacao_entrega  = pe.cd_programacao_entrega and
                                                    i.cd_pedido_venda         = per.cd_pedido_venda and
                                                    i.cd_item_pedido_venda    = per.cd_item_pedido_venda 
    where
      isnull(pe.ic_selecao_programacao,'N') = 'S' and
      isnull(per.cd_previa_faturamento,0) = 0

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_previa_faturamento, 'D'

  end
  else
    begin

      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_previa_faturamento, 'D'
      set @cd_previa_faturamento=0
    end

end

