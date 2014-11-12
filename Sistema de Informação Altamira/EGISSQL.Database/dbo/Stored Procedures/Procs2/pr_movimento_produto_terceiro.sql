

create procedure pr_movimento_produto_terceiro
@ic_parametro         int      = 1,
@cd_tipo_destinatario int      = 0, 
@cd_destinatario      int      = 0, 
@cd_produto           int      = 0,
@dt_inicial           datetime = '',
@dt_final             datetime = '',
@cd_movimento_origem  int      = 0,
@cd_filtro            int      = 0
as

  -- Declara as variáveis de saldo

  declare @vl_saldo   int 
  declare @vl_entrada int 
  declare @vl_saida   int

  -- Inicializa as variáveis

  set @vl_saldo   = 0 
  set @vl_entrada = 0 
  set @vl_saida   = 0


if @ic_parametro = 1   -- CONSULTA DA MOVIMENTAÇÃO
begin
 
  -- Monta Saldo Entrada

  select 
    @vl_entrada = isnull(sum(qt_movimento_terceiro),0) 
  from
    movimento_produto_terceiro with (nolock) 
  where cd_tipo_destinatario = @cd_tipo_destinatario 
    and cd_destinatario      = @cd_destinatario 
    and cd_produto           = @cd_produto
    and ic_tipo_movimento    = 'E'
    and dt_movimento_terceiro < @dt_inicial 
    and isnull(ic_movimento_terceiro,'S')='S'

  -- Saldo Saldo Saída
  select 
    @vl_saida = isnull(sum(qt_movimento_terceiro),0) 
  from 
    movimento_produto_terceiro with (nolock) 
  where cd_tipo_destinatario = @cd_tipo_destinatario 
    and cd_destinatario      = @cd_destinatario 
    and cd_produto           = @cd_produto
    and ic_tipo_movimento    = 'S'
    and dt_movimento_terceiro < @dt_inicial 
    and isnull(ic_movimento_terceiro,'S')='S'
  
  -- Saldo Inicial
  set @vl_saldo = @vl_entrada - @vl_saida
  
  -- Lista o relatório de Movimento de Produtos de Terceiros

  select mp.cd_movimento_produto_terceiro as Codigo,
         @vl_saldo                        as SaldoInicial,

         case when (ic_tipo_movimento = 'S') then
           (select a.cd_nota_entrada from movimento_produto_terceiro a with (nolock) 
            where a.cd_movimento_produto_terceiro = mp.cd_movimento_origem)
         else mp.cd_nota_entrada end 																						as NotaEntrada,

         case when (ic_tipo_movimento = 'E') then  mp.dt_movimento_terceiro 
              else 
           (select a.dt_movimento_terceiro from movimento_produto_terceiro a with (nolock) 
            where a.cd_movimento_produto_terceiro = mp.cd_movimento_origem)  end as DataEntrada,

         p.nm_fantasia_produto as Produto,
         c.nm_fantasia_cliente as Destinatario,

         case when (ic_tipo_movimento = 'E') then 
           case when mp.qt_movimento_terceiro = 0 then null else mp.qt_movimento_terceiro end
         else 
           case when (select a.qt_movimento_terceiro from movimento_produto_terceiro a with (nolock) 
                      where a.cd_movimento_produto_terceiro = mp.cd_movimento_origem) = 0 then null else
                     (select a.qt_movimento_terceiro from movimento_produto_terceiro a with (nolock) 
                      where a.cd_movimento_produto_terceiro = mp.cd_movimento_origem) end end as QtdeEntrada,

         mp.cd_nota_saida as NotaSaida,

         case when (ic_tipo_movimento = 'S') then mp.dt_movimento_terceiro
              else null end as DataSaida,

         case when (ic_tipo_movimento = 'S') then case when mp.qt_movimento_terceiro = 0 then null else mp.qt_movimento_terceiro end
              else null  end as QtdeSaida,

         mp.ic_tipo_movimento as Tipo,
         mp.cd_operacao_fiscal,
         opf.cd_mascara_operacao
  
  from 
    movimento_produto_terceiro mp     with (nolock) 
  inner join Produto p                with (nolock) on mp.cd_produto          = p.cd_produto
  inner join Cliente c                with (nolock) on c.cd_cliente           = mp.cd_destinatario
  left outer join Operacao_Fiscal opf with (nolock) on opf.cd_operacao_fiscal = mp.cd_operacao_fiscal

--select * from movimento_produto_terceiro

  where mp.cd_tipo_destinatario = case when isnull(@cd_tipo_destinatario,0) = 0 then
                                    isnull(mp.cd_tipo_destinatario,0)
                                  else
                                    isnull(@cd_tipo_destinatario,0)
                                  end
    and mp.cd_destinatario = case when isnull(@cd_destinatario,0) = 0 then
                               isnull(mp.cd_destinatario,0)
                             else
                               isnull(@cd_destinatario,0)
                             end  
    and mp.cd_produto = case when isnull(@cd_produto,0) = 0 then
                          isnull(mp.cd_produto,0)
                        else
                          isnull(@cd_produto,0)
                        end
    and mp.dt_movimento_terceiro between @dt_inicial and @dt_final
    and mp.ic_tipo_movimento in ('E','S')
    and isnull(ic_movimento_terceiro,'S')='S'

  order by
     mp.dt_movimento_terceiro desc

end

else if @ic_parametro = 2   -- SALDO EM ABERTO
begin

  -- Monta Saldo Entrada

  select @vl_entrada = isnull(sum(isnull(mp.qt_movimento_terceiro,0)),0) 
  from movimento_produto_terceiro mp with (nolock) 
  where mp.cd_tipo_destinatario = case when isnull(@cd_tipo_destinatario,0) = 0 then
                                    isnull(mp.cd_tipo_destinatario,0)
                                  else
                                    isnull(@cd_tipo_destinatario,0)
                                  end
    and mp.cd_destinatario = case when isnull(@cd_destinatario,0) = 0 then
                               isnull(mp.cd_destinatario,0)
                             else
                               isnull(@cd_destinatario,0)
                             end  
    and mp.cd_produto = case when isnull(@cd_produto,0) = 0 then
                          isnull(mp.cd_produto,0)
                        else
                          isnull(@cd_produto,0)
                        end
    and ic_tipo_movimento = 'E'
    and dt_movimento_terceiro < @dt_inicial 
    and isnull(ic_movimento_terceiro,'S')='S'

  -- Saldo Saldo Saída
  select @vl_saida = isnull(sum(mp.qt_movimento_terceiro),0) 
  from movimento_produto_terceiro mp with (nolock) 
  where mp.cd_tipo_destinatario = case when isnull(@cd_tipo_destinatario,0) = 0 then
                                    isnull(mp.cd_tipo_destinatario,0)
                                  else
                                    isnull(@cd_tipo_destinatario,0)
                                  end
    and mp.cd_destinatario = case when isnull(@cd_destinatario,0) = 0 then
                               isnull(mp.cd_destinatario,0)
                             else
                               isnull(@cd_destinatario,0)
                             end  
    and mp.cd_produto = case when isnull(@cd_produto,0) = 0 then
                          isnull(mp.cd_produto,0)
                        else
                          isnull(@cd_produto,0)
                        end
    and ic_tipo_movimento = 'S'
    and dt_movimento_terceiro < @dt_inicial 
    and isnull(ic_movimento_terceiro,'S')='S'
 
  -- Saldo Inicial
  select SaldoAtual = (@vl_entrada - @vl_saida)

end
else if @ic_parametro = 3   -- TODA A MOVIMENTAÇÃO
begin

  select 
    mp.cd_movimento_produto_terceiro as Codigo,
    mp.cd_nota_entrada               as NotaEntrada,
    mp.dt_movimento_terceiro         as DataEntrada,
    mp.cd_produto                    as CodProduto,
    p.nm_fantasia_produto            as Produto,
    mp.qt_movimento_terceiro         as QtdeEntrada,
    mp.qt_movimento_terceiro - isnull((select sum(x.qt_movimento_terceiro)
                                       from movimento_produto_terceiro x
                                       where x.cd_movimento_origem = mp.cd_movimento_produto_terceiro),0) as Saldo
  from
    movimento_produto_terceiro mp with (nolock),
    produto p with (nolock) 
  where mp.cd_produto = p.cd_produto and 
    mp.cd_tipo_destinatario = case when isnull(@cd_tipo_destinatario,0) = 0 then
                                    isnull(mp.cd_tipo_destinatario,0)
                                  else
                                    isnull(@cd_tipo_destinatario,0)
                                  end
    and mp.cd_destinatario = case when isnull(@cd_destinatario,0) = 0 then
                               isnull(mp.cd_destinatario,0)
                             else
                               isnull(@cd_destinatario,0)
                             end  
    and mp.cd_produto = case when isnull(@cd_produto,0) = 0 then
                          isnull(mp.cd_produto,0)
                        else
                          isnull(@cd_produto,0)
                        end 
    and ic_tipo_movimento = 'E' 
    and isnull(mp.ic_movimento_terceiro,'S')='S'

    and (mp.qt_movimento_terceiro - isnull((select sum(x.qt_movimento_terceiro)
                                        from movimento_produto_terceiro x with (nolock) 
                                        where x.cd_movimento_origem = mp.cd_movimento_produto_terceiro and
                                              x.ic_tipo_movimento in ('E','S')),0) > 0)
 
   order by
     mp.dt_movimento_terceiro desc

end

else if @ic_parametro = 4   -- TODAS AS ENTRADAS DEPENDENDO DO FILTRO UTILIZADO
begin

  select 
    mp.cd_movimento_produto_terceiro     as Codigo,
    mp.ic_tipo_movimento                 as ic_tipo_movimento,
    p.cd_mascara_produto,
    p.nm_produto,
    p.nm_fantasia_produto                as Produto,
    um.sg_unidade_medida,
    c.nm_fantasia_cliente                as Destinatario,
    isnull( mp.qt_movimento_terceiro,0 ) as QtdeEntrada,
    mp.cd_nota_entrada                   as NotaEntrada,
    mp.dt_movimento_terceiro             as DataEntrada,

    isnull((
    select 
      sum( isnull(qt_movimento_terceiro,0) ) 
    from 
      movimento_produto_terceiro a with (nolock) 
    where 
      a.cd_movimento_origem = mp.cd_movimento_produto_terceiro and
      a.ic_tipo_movimento = 'S'
   ),0 )                                 as QtdeSaidaTotal,
    mp.cd_operacao_fiscal,
    opf.cd_mascara_operacao

  into
    #movimento_produto_terceiro_tmp 

  from 
    movimento_produto_terceiro mp       with (nolock) 
    inner join Produto p                with (nolock) on mp.cd_produto          = p.cd_produto
    inner join Cliente c                with (nolock) on c.cd_cliente           = mp.cd_destinatario
    left outer join Unidade_Medida um   with (nolock) on um.cd_unidade_medida   = p.cd_unidade_medida
    left outer join Operacao_Fiscal opf with (nolock) on opf.cd_operacao_fiscal = mp.cd_operacao_fiscal
  where
    mp.cd_tipo_destinatario = case 
                                when isnull(@cd_tipo_destinatario,0) = 0 then
                                  isnull(mp.cd_tipo_destinatario,0)
                                else
                                  isnull(@cd_tipo_destinatario,0)
                              end
    and mp.cd_destinatario  = case 
                                when isnull(@cd_destinatario,0) = 0 then
                                  isnull(mp.cd_destinatario,0)
                                else
                                  isnull(@cd_destinatario,0)
                              end  
    and mp.cd_produto       = case 
                                when isnull(@cd_produto,0) = 0 then
                                  isnull(mp.cd_produto,0)
                                else
                                  isnull(@cd_produto,0)
                              end
    and mp.dt_movimento_terceiro between @dt_inicial and @dt_final
    and mp.ic_tipo_movimento = 'E'
    and isnull(ic_movimento_terceiro,'S')='S'

    order by
      mp.dt_movimento_terceiro

    if @cd_filtro = 0
    begin
      select *, ( QtdeEntrada - case when QtdeSaidaTotal>QtdeEntrada then QtdeEntrada else QtdeSaidaTotal end ) as QtdeSaldo from #movimento_produto_terceiro_tmp
      order by
        DataEntrada
    end

    if @cd_filtro = 1
    begin
      select *, ( QtdeEntrada - case when QtdeSaidaTotal>QtdeEntrada then QtdeEntrada else QtdeSaidaTotal end ) as QtdeSaldo from #movimento_produto_terceiro_tmp
      where ( QtdeEntrada -  case when QtdeSaidaTotal>QtdeEntrada then QtdeEntrada else QtdeSaidaTotal end ) <> 0 
      order by
        DataEntrada
    end

    if @cd_filtro = 2
    begin
      select *, ( QtdeEntrada - case when QtdeSaidaTotal>QtdeEntrada then QtdeEntrada else QtdeSaidaTotal end ) as QtdeSaldo from #movimento_produto_terceiro_tmp
      where ( QtdeEntrada - case when QtdeSaidaTotal>QtdeEntrada then QtdeEntrada else QtdeSaidaTotal end ) = 0 
      order by
         DataEntrada
    end

end

else if @ic_parametro = 5 -- SAIDAS DA ENTRADA
begin

  declare @qt_nota_entrada float

  select
    @qt_nota_entrada = isnull(qt_movimento_terceiro,0)

  from
    movimento_produto_terceiro with (nolock)

  where
    cd_movimento_produto_terceiro = @cd_movimento_origem 

--   --Atualizando o Saldo
-- 
--   select 
--     mp.cd_movimento_produto_terceiro     as Codigo,
--     mp.ic_tipo_movimento                 as ic_tipo_movimento,
--     mp.cd_nota_saida                     as NotaSaida,
--     mp.dt_movimento_terceiro             as DataSaida,
--     mp.cd_item_nota_fiscal               as itemSaida,
--     isnull( mp.qt_movimento_terceiro,0 ) as QtdeSaida,
--     ic_perda_item_nota_saida             as Perda,
--     mp.cd_movimento_origem,
--     @qt_nota_entrada                     as 'Entrada',
--     0.00                                 as 'Saldo'
--   into
--     #GeraSaldo
-- 
--   from 
--     movimento_produto_terceiro mp with (nolock) 
--     left join Nota_Saida_Item nsi on nsi.cd_nota_saida      = mp.cd_nota_saida and
--                                      nsi.cd_item_nota_saida = mp.cd_item_nota_fiscal
--   where
--     mp.cd_movimento_origem = @cd_movimento_origem and
--     mp.ic_tipo_movimento   = 'S'
--     and isnull(mp.ic_movimento_terceiro,'S')='S'
-- 
--   declare @cd_movimento_produto_terceiro int
--   declare @qt_movimento_terceiro         float
--   declare @qt_saldo                      float
-- 
--   set @cd_movimento_produto_terceiro = 0
--   set @qt_saldo                      = @qt_nota_entrada
-- 
--   while exists ( select top 1 Codigo from #GeraSaldo )   
--   begin
--     select top 1
--       @cd_movimento_produto_terceiro = Codigo,
--       @qt_movimento_terceiro         = QtdeSaida
--     from
--       #GeraSaldo
-- 
--     set @qt_saldo = @qt_saldo - @qt_movimento_terceiro
-- 
-- --    select @qt_saldo
-- 
--     if @qt_saldo<0
--     begin
--       --Deleta o Movimento de Terceiro
--       delete from movimento_produto_terceiro 
--       where
--         cd_movimento_produto_terceiro = @cd_movimento_produto_terceiro 
--     end
-- 
--     delete from #GeraSaldo
--     where
--       Codigo = @cd_movimento_produto_terceiro
--   end

  select 
    mp.cd_movimento_produto_terceiro     as Codigo,
    mp.ic_tipo_movimento                 as ic_tipo_movimento,
--    mp.cd_nota_saida                     as NotaSaida,

    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
      ns.cd_identificacao_nota_saida
    else
      ns.cd_nota_saida                              
    end                                  as NotaSaida,

    mp.dt_movimento_terceiro             as DataSaida,
    mp.cd_item_nota_fiscal               as itemSaida,
    isnull( mp.qt_movimento_terceiro,0 ) as QtdeSaida,
    ic_perda_item_nota_saida             as Perda,
    mp.cd_movimento_origem,
    @qt_nota_entrada                     as 'Entrada',
    0.00                                 as 'Saldo'

  from 
    movimento_produto_terceiro mp with (nolock) 
    left join Nota_Saida_Item nsi on nsi.cd_nota_saida      = mp.cd_nota_saida    and
                                     nsi.cd_item_nota_saida = mp.cd_item_nota_fiscal
    left join Nota_Saida      ns  on ns.cd_nota_saida       = nsi.cd_nota_saida 

  where
    mp.cd_movimento_origem = @cd_movimento_origem and
    mp.ic_tipo_movimento   = 'S'
    and isnull(mp.ic_movimento_terceiro,'S')='S'

end

