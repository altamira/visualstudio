
CREATE PROCEDURE pr_recomposicao_saldo_automatico

as

declare @dt_ini_rec  datetime
declare @dt_fec_rec  datetime
declare @dt_fim_rec  datetime
declare @cd_grp_rec  int
declare @cd_fase_rec int

set @dt_ini_rec = convert(datetime,left(convert(varchar,getdate(),121),8)+'01',121)
set @dt_fec_rec = @dt_ini_rec-1
set @dt_fim_rec = getdate()

print @dt_ini_rec
print @dt_fec_rec
print @dt_fim_rec

select cd_grupo_produto into #tmp_grupo from grupo_produto

while exists (select top 1 * from #tmp_grupo)
begin

  select top 1 @cd_grp_rec = isnull(cd_grupo_produto,0) from #tmp_grupo where isnull(cd_grupo_produto,0) > 0

  select cd_fase_produto  into #tmp_fase  from fase_produto

  while exists (select top 1 * from #tmp_fase)
  begin

     select top 1 @cd_fase_rec = isnull(cd_fase_produto,0) from #tmp_fase

     print 'Recompondo Grupo : '
     print @cd_grp_rec
     print 'Fase : '
     print @cd_fase_rec

     EXECUTE pr_recomposicao_saldo
     @ic_parametro     = 1, --1:grupo  3:serie  5:produto
     @dt_fechamento    = @dt_fec_rec,
     @dt_inicial       = @dt_ini_rec,
     @dt_final         = @dt_fim_rec,
     @cd_produto       = 0,
     @cd_grupo_produto = @cd_grp_rec,
     @cd_serie_produto = 0,
     @cd_fase_produto  = @cd_fase_rec

     delete from #tmp_fase where cd_fase_produto=@cd_fase_rec

  end

  delete from #tmp_grupo where cd_grupo_produto=@cd_grp_rec
  drop table #tmp_fase

end

drop table #tmp_grupo

