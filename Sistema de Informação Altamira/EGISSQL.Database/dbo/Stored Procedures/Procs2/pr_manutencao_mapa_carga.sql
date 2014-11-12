
-------------------------------------------------------------------------------
--sp_helptext pr_manutencao_mapa_carga
-------------------------------------------------------------------------------
--pr_manutencao_mapa_carga
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Manutenção Geral no Mapa de Carga
--
--Data             : 12.03.2009
--Alteração        : 17.03.2009
--
--
------------------------------------------------------------------------------
create procedure pr_manutencao_mapa_carga
@ic_parametro  int      = 0,
@dt_inicial    datetime = '',
@dt_final      datetime = '',
@cd_veiculo    int      = 0,
@cd_motorista  int      = 0,
@cd_usuario    int      = 0,
@cd_nota_saida int     = 0

as

--Utilização da Tabela Auxiliar Mapa_Carga

--select * from vendedor
--select * from nota_saida
--select * from mapa_carga
--select * from veiculo
--select cd_veiculo,cd_motorista,* from motorista

------------------------------------------------------------------------------
--Zeramento do Mapa de Carga por Período
------------------------------------------------------------------------------

if @ic_parametro = 1
begin
  update
    nota_saida
  set
    cd_veiculo   = null,
    cd_motorista = null
  from
    nota_saida 
  where
    dt_nota_saida between @dt_inicial and @dt_final and
    cd_veiculo   = case when @cd_veiculo   = 0 then cd_veiculo   else @cd_veiculo   end and
    cd_motorista = case when @cd_motorista = 0 then cd_motorista else @cd_motorista end 
    
end

------------------------------------------------------------------------------
--Alteração do Mapa de Carga Manual
------------------------------------------------------------------------------

if @ic_parametro = 2
begin

  update
    nota_saida
  set
    cd_veiculo   = @cd_veiculo,
    cd_motorista = @cd_motorista
  from
    nota_saida 
  where
    cd_nota_saida = @cd_nota_saida
  
end

------------------------------------------------------------------------------
--Alteração do Mapa de Carga por Período
------------------------------------------------------------------------------

if @ic_parametro = 3
begin
  print '3'
 
end

------------------------------------------------------------------------------
--Montagem do Mapa de Carga novamente
------------------------------------------------------------------------------

if @ic_parametro = 4
begin
  --print '4'

  declare @cd_vendedor        int
  declare @cd_criterio_visita int

  select
    ns.cd_nota_saida,
    ns.cd_vendedor,
    ns.cd_veiculo,
    ns.cd_motorista,
    c.cd_criterio_visita    
  into
    #MontaCarga

  from
    Nota_Saida ns        with (nolock) 
    inner join Cliente c with (nolock) on c.cd_cliente = ns.cd_cliente 
  where
    ns.dt_nota_saida between @dt_inicial and @dt_final

  while exists ( select top 1 cd_nota_saida from #MontaCarga )
  begin
    select top 1
      @cd_nota_saida      = cd_nota_saida,
      @cd_vendedor        = cd_vendedor,
      @cd_criterio_visita = cd_criterio_visita
    from
      #MontaCarga

    --Veículo

    select 
      top 1
        @cd_veiculo = isnull(cd_veiculo,0)
      from
        Veiculo_Area_Regiao va     with (nolock) 
        inner join area_entrega ae with (nolock) on ae.cd_area_entrega = va.cd_area_entrega
      where
        va.cd_vendedor        = @cd_vendedor  and
        ae.cd_criterio_visita = @cd_criterio_visita 

     --Motorista

     select
       top 1
         @cd_motorista = isnull(cd_motorista,0)
     from
         Motorista with (nolock) 
     where
         cd_veiculo = @cd_veiculo

     --Atualiza a Nota Fiscal

     update 
       nota_saida
     set
       cd_veiculo   = @cd_veiculo,
       cd_motorista = @cd_motorista
     from
       nota_saida
     where
       cd_nota_saida = @cd_nota_saida


     delete from #MontaCarga where cd_nota_saida = @cd_nota_saida

  end
 
end


