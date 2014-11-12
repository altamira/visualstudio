
CREATE PROCEDURE pr_maquina_estampo
@qt_tonelagem        float = 0,
@qt_diametro_externo float = 0,
@qt_espessura        float = 0

as 

begin

  declare @cd_maquina                  int
  declare @qt_tonelagem_maquina        float  
  declare @qt_diametro_externo_maquina float
  declare @qt_espessura_maquina        float
  declare @cd_maquina_retorno          int
  declare @qt_diametro_externo_final   float
 
  select 
    *
  into 
    #MaquinaEstampo
  from
    Maquina_Estampo

--   select * from #MaquinaEstampo
--   order by
--       qt_tonelagem_maquina,
--       qt_diametro_externo,
--       qt_espessura

  while exists ( select top 1 cd_maquina from #MaquinaEstampo )
  begin
  
    set @cd_maquina_retorno = 0

    select top 1
      @cd_maquina                   = cd_maquina,
      @cd_maquina_retorno           = cd_maquina,
      @qt_tonelagem_maquina         = qt_tonelagem_maquina,
      @qt_diametro_externo_maquina  = qt_diametro_externo,
      @qt_espessura_maquina         = qt_espessura,
      @qt_diametro_externo_final    = qt_diametro_externo_final
    from
      #MaquinaEstampo
    order by
      qt_tonelagem_maquina,
      qt_diametro_externo,
      qt_espessura

--     select
--       @cd_maquina,                   
--       @qt_tonelagem_maquina,
--       @qt_diametro_externo_maquina,
--       @qt_espessura_maquina


    --Tonelagem

    if @qt_tonelagem_maquina>=@qt_tonelagem 
    begin
      --select @cd_maquina,@qt_tonelagem_maquina,@qt_tonelagem, @qt_diametro_externo,@qt_diametro_externo_maquina

      if @qt_diametro_externo<=@qt_diametro_externo_final
         begin
           set @cd_maquina_retorno = @cd_maquina
              break

         end 
    end

    delete from #MaquinaEstampo where cd_maquina = @cd_maquina

  end  
 
  --Busca a Data de Disponibilidade

  declare @dt_disp_carga_maquina datetime

  select 
    @dt_disp_carga_maquina = isnull(dt_disp_carga_maquina,getdate())
  from 
    Carga_Maquina cm 
  where
    cm.cd_maquina = @cd_maquina_retorno

  select
    @cd_maquina_retorno    as cd_maquina,
    @dt_disp_carga_maquina as Disponibilidade,
    m.nm_fantasia_maquina
  from
    Maquina m 
  where
    m.cd_maquina = @cd_maquina_retorno 

--select * from carga_maquina
--select * from maquina

end

