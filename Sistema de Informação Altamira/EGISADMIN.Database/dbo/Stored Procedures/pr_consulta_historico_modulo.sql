
CREATE   PROCEDURE pr_consulta_historico_modulo
  @dt_inicial as DateTime,
  @dt_final as DateTime,
  @sg_modulo varchar(20),
  @ic_parametro int --1 - Retorna o Histórico / 2 - Retorna as Procedures
AS
Begin

if ( @ic_parametro = 1 )
begin
  select 
    distinct
    mh.nm_os,
    (Select top 1 nm_menu_titulo from menu where nm_unit_menu = mh.nm_unit_menu order by cd_menu) as nm_titulo,
    mh.nm_solicitante,
    case mh.nm_empresa
      when 'GBS-Testes' then 'GBS'
      else mh.nm_empresa
    end as nm_empresa,
    ltrim(cast(ds_menu_historico as varchar(2000))) as Historico
  from
    Menu_Historico mh
    inner join Menu m 
      on mh.nm_unit_menu = m.nm_unit_menu 
      and len(mh.nm_unit_menu) > 0
    inner join Modulo_Funcao_Menu mfm
      on m.cd_menu = mfm.cd_menu
    inner join Modulo mod
      on mfm.cd_modulo = mod.cd_modulo
      and
      ic_liberado = 'S'
      and   
      ( ( @sg_modulo = '' ) or ( ( @sg_modulo <> '' ) and ( mod.sg_modulo = @sg_modulo ) ) )
    inner join modulo_historico modh
      on mod.cd_modulo = modh.cd_modulo and dt_modulo_historico between @dt_inicial and @dt_final

end
else if ( @ic_parametro = 2 )
begin
  select 
    mod.sg_modulo,
    mod.nm_modulo,
    count(mh.cd_menu_historico) as qt_os_modulo
  from
    Menu_Historico mh
    inner join Menu m 
      on mh.nm_unit_menu = m.nm_unit_menu
      and len(mh.nm_unit_menu) > 0
    inner join Modulo_Funcao_Menu mfm
      on m.cd_menu = mfm.cd_menu
    inner join Modulo mod
      on mfm.cd_modulo = mod.cd_modulo
      and
      ic_liberado = 'S'
      and   
      ( ( @sg_modulo = '' ) or ( ( @sg_modulo <> '' ) and ( mod.sg_modulo = @sg_modulo ) ) )
    inner join modulo_historico modh
      on mod.cd_modulo = modh.cd_modulo and dt_modulo_historico between @dt_inicial and @dt_final
  group by
    mod.sg_modulo,
    mod.nm_modulo
end
else
begin
  select 
    distinct
    mh.nm_os,
    (Select top 1 nm_menu_titulo from menu where nm_unit_menu = mh.nm_unit_menu order by cd_menu) as nm_titulo,
    mh.nm_solicitante,
    case mh.nm_empresa
      when 'GBS-Testes' then 'GBS'
      else mh.nm_empresa
    end as nm_empresa,
    cast(nm_procedure as varchar(2000)) as Historico
  from
    Menu_Historico_Procedure mhp
    inner join Menu_Historico mh
      on mhp.cd_menu_historico  = mh.cd_menu_historico
    inner join Menu m 
      on mh.nm_unit_menu = m.nm_unit_menu
      and len(mh.nm_unit_menu) > 0
    inner join Modulo_Funcao_Menu mfm
      on m.cd_menu = mfm.cd_menu
    inner join Modulo mod
      on mfm.cd_modulo = mod.cd_modulo
      and
      ic_liberado = 'S'
      and   
      ( ( @sg_modulo = '' ) or ( ( @sg_modulo <> '' ) and ( mod.sg_modulo = @sg_modulo ) ) )
    inner join modulo_historico modh
      on mod.cd_modulo = modh.cd_modulo and dt_modulo_historico between @dt_inicial and @dt_final
end

end

