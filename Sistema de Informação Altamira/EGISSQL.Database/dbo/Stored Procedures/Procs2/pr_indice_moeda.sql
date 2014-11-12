
create procedure pr_indice_moeda
@cd_moeda    int,
@dt_moeda    datetime,
@vl_indice   float output

as
  while not exists 
    (select dt_moeda from valor_moeda where dt_moeda=@dt_moeda)
     set @dt_moeda=@dt_moeda-1

  begin
    set @vl_indice=(select vl_moeda
                    from Valor_Moeda 
                    where cd_moeda = @cd_moeda and
                    dt_moeda = @dt_moeda)
    print @vl_indice

  end
